#!/bin/bash
GH_REPOSITORIES="XTLS/Xray-core"
AMD64="64"
ARM64="arm64-v8a"
GH_REPOSITORIES_API="https://api.github.com/repos/${GH_REPOSITORIES}/releases/latest"
message=`curl -s $GH_REPOSITORIES_API`
IMAGES_TAG_NAME=`echo $message | jq .tag_name`
echo $IMAGES_TAG_NAME
BROWSER_DOWNLOAD_URL="https://github.com/${GH_REPOSITORIES}/releases/latest/download/Xray-linux-${ARCH}.zip"
#echo $BROWSER_DOWNLOAD_URL
DIR="xray"
GEOIP="geoip.dat"
GEOSITE="geosite.dat"
ROOTFS="rootfs.tar.xz"
USER="fly97"

ARCH=AMD64
# if [  -f "$ARCH" ]; then
#     echo "$ARCH file is exist.."
# else
#     # 下载二进制
#     echo "Download $ARCH..."
#     # ARCH=AMD64
#     # wget $BROWSER_DOWNLOAD_URL
# fi


if [ ! -d "$DIR" ]; then
    mkdir -p $DIR
    unzip -d $DIR $ARCH
else 
    echo "dir $DIR is exist.."
fi

cd $DIR
echo "inter $DIR dir.."
if [ ! -f "$GEOIP" ]; then
    wget -O $GEOIP "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/${GEOIP}"
fi
if [ ! -f "$GEOSITE" ]; then
    wget -O $GEOSITE "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/${GEOSITE}"
fi
echo "remove unnecessary files.."
rm -rf LICENSE README.md

# cd ..
# echo "inter main DIR.."

# if [ ! -f "$ROOTFS" ]; then
#     wget -O $ROOTFS "https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-amd64/bullseye/rootfs.tar.xz"
# else 
#     echo "$ROOTFS is exist.."
# fi
# 长度是否等于零
if [ -z `type -P docker` ]; then
    echo "docker is not installed.."
    exit -1
fi

echo "Prepare to package the image.."
cp ../Dockerfile Dockerfile
echo "Login in Docker Hub..."
echo $DOCKER_TOKEN | docker login -u $DOCKER_USER --password-stdin
docker run --rm --privileged tonistiigi/binfmt:latest --install all
echo "Test OK"
docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t $USER/$DIR . --push
echo "Build OK"








