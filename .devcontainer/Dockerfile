
# Base image with common dev tooling
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ARG KUBECTL_VERSION=v1.29.6
ARG KIND_VERSION=v0.23.0
ARG HELM_VERSION=v3.14.4
ARG K9S_VERSION=v0.32.5
ARG YQ_VERSION=v4.44.3
ARG STERN_VERSION=v1.30.0

# Create non-root dev user (devcontainers base already has 'vscode')
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git make bash-completion \
    jq tar unzip build-essential software-properties-common \
    iproute2 iputils-ping netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Install kind
RUN curl -fsSL -o /usr/local/bin/kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64 \
    && chmod +x /usr/local/bin/kind

# Install helm
RUN curl -fsSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    | tar -xz && mv linux-amd64/helm /usr/local/bin/helm && rm -rf linux-amd64

# Install k9s
RUN curl -fsSL -o /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz \
    && tar -xzf /tmp/k9s.tar.gz -C /usr/local/bin k9s && rm /tmp/k9s.tar.gz

# Install yq
RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# Install stern
RUN curl -fsSL -o /usr/local/bin/stern https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 \
    && chmod +x /usr/local/bin/stern

# Bash completion for kubectl, helm; quality-of-life aliases
RUN kubectl completion bash > /etc/bash_completion.d/kubectl \
 && helm completion bash > /etc/bash_completion.d/helm

# Prepare kube directories
RUN mkdir -p /home/vscode/.kube \
    && chown -R vscode:vscode /home/vscode/.kube

# Add helpful aliases and prompt
RUN echo '\n# CKAD goodies' >> /etc/bash.bashrc \
    && echo 'alias k=kubectl' >> /etc/bash.bashrc \
    && echo 'complete -o default -F __start_kubectl k' >> /etc/bash.bashrc \
    && echo 'alias kgp="kubectl get pods -A"' >> /etc/bash.bashrc \
    && echo 'alias kgs="kubectl get svc -A"' >> /etc/bash.bashrc \
    && echo 'alias kctx="kubectl config current-context"' >> /etc/bash.bashrc \
    && echo 'alias kns="kubectl config set-context --current --namespace"' >> /etc/bash.bashrc \
    && echo 'alias kdash="k9s"' >> /etc/bash.bashrc

# Copy helper scripts
COPY scripts /usr/local/share/ckad/scripts
RUN chmod +x /usr/local/share/ckad/scripts/*.sh

# Copy kind config
COPY kind-config.yaml /usr/local/share/ckad/kind-config.yaml

# Copy postCreate
COPY postCreate.sh /usr/local/share/ckad/postCreate.sh
RUN chmod +x /usr/local/share/ckad/postCreate.sh

# Switch back to vscode user
USER vscode
WORKDIR /workspaces
