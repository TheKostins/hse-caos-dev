FROM ubuntu:24.04

ARG USER=dev 
ARG UID=1001
ARG GID=1001
ARG DEBIAN_FRONTEND=noninteractive

RUN rm -f /etc/dpkg/dpkg.cfg.d/01_nodoc /etc/dpkg/dpkg.cfg.d/docker || true

RUN yes | unminimize && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential pkg-config \
    gcc g++ gcc-multilib \
    gdb cmake clang-format \
    nasm fasm \
    binutils \
    zsh git curl ca-certificates \
    neovim strace valgrind\
    sudo tmux \
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

USER ${USER}
ENV HOME=/home/${USER} \
    CARGO_HOME=/home/${USER}/.cargo \
    RUSTUP_HOME=/home/${USER}/.rustup
# put cargo on PATH for all subsequent layers & at runtime
ENV PATH=${CARGO_HOME}/bin:${PATH}
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y \
      --default-toolchain nightly-x86_64-unknown-linux-gnu \
      --profile minimal \
 && rustup component add --toolchain nightly rust-src rustfmt clippy \
 && rustc --version && cargo --version



SHELL ["/usr/bin/zsh","-lc"]
RUN curl -fsSL https://git.io/zinit-install | zsh

COPY --chown=${USER}:${GID} zshrc /home/${USER}/.zshrc
COPY --chown=${UID}:${GID} zinit-preload.zsh /home/${USER}/.zinit-preload.zsh

RUN source ~/.zinit-preload.zsh; zcompile ~/.zshrc

COPY --chown=${UID}:${GID} zprofile /home/${USER}/.zprofile

SHELL ["/bin/sh","-c"]

RUN mkdir -p /home/${USER}/.cargo/registry \
             /home/${USER}/.cargo/git \
 && chown -R ${UID}:${GID} /home/${USER}/.cargo

VOLUME ["/home/dev/.cargo/registry", "/home/dev/.cargo/git"]

CMD ["/usr/bin/zsh"]
