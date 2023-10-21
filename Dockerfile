FROM docker.io/golang:1.20-bullseye AS build
LABEL authors="QianheYu"

WORKDIR /src
COPY . .

RUN apt-get update && apt-get install -y git

RUN make build

FROM docker.io/debian:bullseye-slim
LABEL authors="QianheYu"
LABEL all-in-one=true

RUN apt-get update && apt-get install -y ca-certificates wget

RUN mkdir -p /etc/headscale-panel && mkdir -p /etc/headscale && mkdir -p /var/lib/headscale && mkdir -p /var/run/headscale && wget /bin/headscale https://github.com/juanfont/headscale/releases/download/v0.22.3/headscale_0.22.3_linux_amd64 && chmod +x /bin/headscale

COPY --from=build /src/bin/headscale-panel /bin/headscale-panel
ENV TZ UTC

CMD ["headscale-panel"]
