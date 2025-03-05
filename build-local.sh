#!/usr/bin/bash

mkdir -p /opt/tmp
rm -rf /opt/tmp/build-kodi
cp -r . /opt/tmp/build-kodi
pushd /opt/tmp/build-kodi
rm -rf .git

sed -i "2a\RUN apt install -y ca-certificates" Dockerfile
sed -i '3a\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '4a\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '5a\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '6a\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '7a\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '8a\RUN apt update' Dockerfile

./build.sh 192.168.13.73:5000/sleechengn/vscode:latest
docker push 192.168.13.73:5000/sleechengn/vscode:latest

popd
