FROM lsiodev/kasmvnc-base:ubuntujammy
RUN apt update
RUN apt -y install fonts-noto-cjk-extra unzip openssh-server git xz-utils python3-pip konsole nano vim psmisc procps net-tools python3-pip
RUN apt -y install konsole \
	&& apt install -y language-pack-zh-hans \
	&& locale-gen zh_CN.UTF-8 \
	&& update-locale LANG=zh_CN.UTF-8
ENV SHELL=/usr/bin/bash

RUN set -e \
	&& apt install -y aria2


#install graalvm
RUN set -e \
        && mkdir -p /opt/graalvm \
        && cd /opt/graalvm \
        && aria2c --max-connection-per-server=10 --min-split-size=1M --max-concurrent-downloads=10 https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-x64_bin.tar.gz \
        && tar -zxvf ./graalvm-jdk-21_linux-x64_bin.tar.gz \
        && rm -rf ./graalvm-jdk-21_linux-x64_bin.tar.gz \
        && ln -s /opt/graalvm/graalvm-jdk-21.0.6+8.1/bin/java /usr/bin/java \
        && ln -s /opt/graalvm/graalvm-jdk-21.0.6+8.1/bin/javac /usr/bin/javac \
        && ln -s /opt/graalvm/graalvm-jdk-21.0.6+8.1/bin/native-image /usr/bin/native-image
ENV JAVA_HOME=/opt/graalvm/graalvm-jdk-21.0.6+8.1
ENV GRAALVM_HOME=/opt/graalvm/graalvm-jdk-21.0.6+8.1




#install VSCode
RUN set -e \
	&& export DEBIAN_FRONTEND="noninteractive" \
	&& aria2c -j 10 -x 10 https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code_1.97.2-1739406807_amd64.deb -o "vsc.deb" \
	&& apt install -y ./vsc.deb --assume-yes --force-yes \
	&& rm -rf vsc.deb

RUN set -e \
	&& code --extensions-dir /config/vscode/extensions --user-data-dir /config/vscode/user --install-extension vscjava.vscode-java-pack \
	&& code --extensions-dir /config/vscode/extensions --user-data-dir /config/vscode/user --install-extension vscjava.vscode-lombok \
	&& code --extensions-dir /config/vscode/extensions --user-data-dir /config/vscode/user --install-extension alphabotsec.vscode-eclipse-keybindings \
	&& code --extensions-dir /config/vscode/extensions --user-data-dir /config/vscode/user --install-extension ms-python.vscode-pylance \
	&& code --extensions-dir /config/vscode/extensions --user-data-dir /config/vscode/user --install-extension ms-python.python

# kasmvnc autostart and menu
COPY ./root /
