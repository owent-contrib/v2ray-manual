#!/bin/bash

which node > /dev/null 2>&1;
if [ $? -ne 0 ]; then
  NODEJS_URL=https://nodejs.org/dist/v12.13.1/node-v12.13.1-linux-x64.tar.xz
  if [ ! -e "$HOME/prebuilt/nodejs" ]; then
    NODEJS_BASENAME=$(basename $NODEJS_URL)
    curl -sL $NODEJS_URL -O $NODEJS_BASENAME
    tar -axvf $NODEJS_BASENAME
    mkdir -p "$HOME/prebuilt"
    mv ${NODEJS_BASENAME%%.tar.*} "$HOME/prebuilt/nodejs";
  fi

  export PATH="$HOME/prebuilt/nodejs/bin:$PATH"
  npm install -g gitbook-cli
else
  sudo npm install -g gitbook-cli
fi

find . -name "*.md" | xargs sed -i -r 's;https://www.v2ray.com;https://v2ray.mdoc.xyz;g'
find . -name "*.html" | xargs sed -i -r 's;https://www.v2ray.com;https://v2ray.mdoc.xyz;g'

# curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
# sudo apt -y install jq git file nodejs build-essential

function build_dir {
  DIR="$1"
  pushd $DIR
  rsync -rv ../_layouts/ ./_layouts/
  rsync -rv ../resources/ ./resources/
  gitbook init
  gitbook install
  gitbook build
  popd  
}

build_dir zh_cn
build_dir en
build_dir ru
build_dir ko
build_dir fa
build_dir vi

TARGET_DIR=_v2ray_com

# git clone "https://github.com/v2ray/v2ray.github.io.git" ${TARGET_DIR}
mkdir -p ${TARGET_DIR}

rm -rf ${TARGET_DIR}/*
cp -r ./zh_cn/_book/* ${TARGET_DIR}/
mkdir ${TARGET_DIR}/en/
cp -r ./en/_book/* ${TARGET_DIR}/en/
mkdir ${TARGET_DIR}/ru/
cp -r ./ru/_book/* ${TARGET_DIR}/ru/
mkdir ${TARGET_DIR}/ko/
cp -r ./ko/_book/* ${TARGET_DIR}/ko/
mkdir ${TARGET_DIR}/fa/
cp -r ./fa/_book/* ${TARGET_DIR}/fa/
mkdir ${TARGET_DIR}/vi/
cp -r ./vi/_book/* ${TARGET_DIR}/vi/
cp -r ./_dev/* ${TARGET_DIR}/
cp CNAME ${TARGET_DIR}/
cp robots.txt ${TARGET_DIR}/
cp -r ./resources/* ${TARGET_DIR}/resources/

# pushd ${TARGET_DIR}
# git config user.name "V2Ray Auto Build"
# git config user.email "admin@v2ray.com"

# git add -A
# git commit -m 'update'
# git push "https://${GITHUB_TOKEN}@github.com/v2ray/v2ray.github.io.git" master
# popd
