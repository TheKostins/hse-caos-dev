FROM ubuntu:24.04

ARG USER=dev 
ARG UID=1001
ARG GID=1001
ARG DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/dpkg/dpkg.cfg.d/01_nodoc /etc/dpkg/dpkg.cfg.d/docker || true

RUN yes | unminimize

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc g++ gcc-multilib \
    gdb \
    nasm fasm \
    binutils \
    zsh git curl ca-certificates \
    neovim \
    sudo tmux\
    man-db manpages manpages-dev manpages-posix manpages-posix-dev \
    less groff-base locales \
 && sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
 && locale-gen \
 && mandb -c \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} ${USER} \
    && useradd -m -u ${UID} -g ${GID} -s /usr/bin/zsh ${USER} \
    && usermod -aG sudo ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR /project

SHELL ["/usr/bin/zsh","-lc"]
RUN curl -fsSL https://git.io/zinit-install | zsh

COPY --chown=${USER}:${GID} zshrc /home/${USER}/.zshrc
COPY --chown=${UID}:${GID} zinit-preload.zsh /home/${USER}/.zinit-preload.zsh

RUN source ~/.zinit-preload.zsh; zcompile ~/.zshrc

COPY --chown=${UID}:${GID} zprofile /home/${USER}/.zprofile

SHELL ["/bin/sh","-c"]

CMD ["/usr/bin/zsh"]
