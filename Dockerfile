FROM registry.cn-hangzhou.aliyuncs.com/snakevil/gitolite
MAINTAINER Snakevil Zen <zsnakevil@gmail.com>

ARG version=latest

EXPOSE 3000
VOLUME ["/mnt/redmine", "/mnt/log"]

RUN BUILD_DATE=20161026 \
 && apk add --no-cache ruby-bundler ruby-rdoc ruby-irb sudo \
        ruby-dev gcc g++ make cmake mariadb-dev libssh2-dev imagemagick-dev \
 && adduser -h /srv/redmine -s /bin/sh -G nobody -S -D redmine \
 && passwd -u redmine
ADD include/redmine-${version}.tar.xz include/themes/* include/plugins/* share/docker/ /
RUN chown -R redmine:nobody /srv/redmine \
 && su - redmine -c "bundle config mirror.https://rubygems.org https://ruby.taobao.org" \
 && su - redmine -c "bundle install --without development test" \
 && apk del ruby-dev gcc g++ make cmake mariadb-dev libssh2-dev imagemagick-dev
RUN apk add --no-cache libstdc++ mariadb-client-libs tzdata imagemagick python \
 && echo 'Defaults:redmine !requiretty' > /etc/sudoers.d/redmine \
 && echo 'redmine ALL=(git) NOPASSWD:ALL' >> /etc/sudoers.d/redmine
