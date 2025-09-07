# Docker Image для CAOS курса

Это образ в котором установлены все нужные штуки для курса (возможны аптдейты) + я сделал конфиг для zsh.

Чтобы запустить в текущей папке:

```bash
docker run --rm -it --platform=linux/amd64 -v "$PWD":/project thekostins/hse-caos-dev:latest
```


