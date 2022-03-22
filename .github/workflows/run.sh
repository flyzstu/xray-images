#!/bin/bash
GH_REPOSITORIES="XTLS/Xray-core"
ARCH="Xray-linux-64.zip"
GH_REPOSITORIES_API="https://api.github.com/repos/${GH_REPOSITORIES}/releases/latest"
message=`curl -s $GH_REPOSITORIES_API`
IMAGES_TAG_NAME=`echo $message | jq .tag_name`
echo $IMAGES_TAG_NAME
BROWSER_DOWNLOAD_URL="https://github.com/${GH_REPOSITORIES}/releases/latest/download/${ARCH}"
#echo $BROWSER_DOWNLOAD_URL
DIR="xray"
GEOIP="geoip.dat"
GEOSITE="geosite.dat"
ROOTFS="rootfs.tar.xz"


if [  -f "$ARCH" ]; then
    echo "$ARCH file is exist.."
else
    # 下载二进制
    wget $BROWSER_DOWNLOAD_URL
fi


if [ ! -f "$ARCH" ]; then
    echo "$ARCH is NOT exist"
    exit -1
else
    # 如果文件不存在就解压文件
    if [ ! -d "$DIR" ]; then
        mkdir -p $DIR
        unzip -d $DIR $ARCH
    else 
        echo "dir $DIR is exist.."
    fi
fi

cd $DIR
echo "inter $DIR dir.."
if [ ! -f "$GEOIP" ]; then
    wget -O $GEOIP "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
fi
if [ ! -f "$GEOSITE" ]; then
    wget -O $GEOSITE "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
fi

echo "remove unnecessary files.."
rm -rf LICENSE README.md

# cd ..
# echo "inter main DIR.."

if [ ! -f "$ROOTFS" ]; then
    wget -O $ROOTFS "https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-amd64/bullseye/rootfs.tar.xz"
else 
    echo "$ROOTFS is exist.."
fi
# 长度是否等于零
if [ -z `type -P docker` ]; then
    echo "docker is not installed.."
    exit -1
fi

echo "Prepare to package the image.."
cp ../Dockerfile ../$DIR/Dockerfile
docker build . -t $DIR:`eval echo $IMAGES_TAG_NAME`
echo "Build OK"

echo "Prepare to push the image.."
docker tag $DIR:`eval echo $IMAGES_TAG_NAME` $DOCKER_USER/$DIR:`eval echo $IMAGES_TAG_NAME`

echo $DOCKER_TOKEN | docker login -u $DOCKER_USER --password-stdin

docker push $DOCKER_USER/$DIR:`eval echo $IMAGES_TAG_NAME`



