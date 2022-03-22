FROM scratch
ADD rootfs.tar.xz /
ADD geosite.dat geoip.dat xray /usr/local/bin/
CMD xray -c /tmp/*.json
