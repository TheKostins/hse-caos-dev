# Docker Image для CAOS курса

Это образ в котором установлены все нужные штуки для курса (возможны аптдейты) + я сделал конфиг для zsh.

Перед установкой нужно создать кэш для `cargo` (Зачем вообще его юзать?)

```bash
docker volume create cargo-reg
docker volume create cargo-git
```

Чтобы запустить в текущей папке:

```bash
docker run --rm -it \
  --platform=linux/amd64 -v "$PWD":/project \
  -v cargo-reg:/home/dev/.cargo/registry \
  -v cargo-git:/home/dev/.cargo/git \
  thekostins/hse-caos-dev:latest
```
