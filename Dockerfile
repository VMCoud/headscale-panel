FROM docker.io/golang:1.20-bullseye AS build
LABEL authors="QianheYu"

WORKDIR /src
COPY . .

RUN apt-get update && apt-get install -y git

RUN make build

FROM headscale/headscale:0.22.3
LABEL authors="QianheYu"
LABEL all-in-one=true

RUN apt-get update && apt-get install -y ca-certificates wget

RUN mkdir -p /etc/headscale-panel && mkdir -p /etc/headscale && mkdir -p /var/lib/headscale && mkdir -p /var/run/headscale

COPY --from=build /src/bin/headscale-panel /bin/headscale-panel
ENV TZ UTC

CMD ["headscale-panel"]
