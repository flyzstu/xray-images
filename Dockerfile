FROM teddysun/xray AS builder
FROM debian:stable-slim
COPY --from=builder /usr/bin/xray /usr/local/bin/xray
ADD geosite.dat geoip.dat /usr/local/bin/
CMD xray -c /tmp/*.json
