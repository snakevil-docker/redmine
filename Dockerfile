FROM registry.cn-hangzhou.aliyuncs.com/snakevil/gitolite
MAINTAINER Snakevil Zen <zsnakevil@gmail.com>

ARG version=latest

EXPOSE 3000
VOLUME /var/lib/redmine

RUN BUILD_DATE=20160927 && \
    apk add --no-cache ruby-bundler ruby-dev ruby-irb ruby-rdoc sudo gcc make \
        libc-dev cmake mariadb-dev imagemagick-dev tzdata g++ libssh2-dev supervisor
ADD include/redmine-${version}.tar.xz include/themes/* include/plugins/* /srv/
RUN cd /srv/redmine && \
    chown -R root:root . && \
    rm -fr files && \
    ln -s /var/lib/redmine files && \
    echo "production:" > config/database.yml && \
    echo "  adapter: mysql2" >> config/database.yml && \
    echo "gem 'rbpdf-font'" > Gemfile.local && \
    echo "gem 'bigdecimal'" >> Gemfile.local && \
    adduser -h /srv/redmine -s /bin/sh -G docker -S -D redmine && \
    passwd -u redmine && \
    mkdir .ssh && \
    chmod 0700 .ssh && \
    echo "Host localhost" > .ssh/config && \
    echo "  HostName 127.0.0.1" >> .ssh/config && \
    echo "  RequestTTY no" >> .ssh/config && \
    echo "  StrictHostKeyChecking no" >> .ssh/config && \
    echo "Defaults:redmine !requiretty" > /etc/sudoers.d/redmine && \
    echo "redmine ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/redmine && \
    echo "redmine ALL=(git) NOPASSWD:ALL" >> /etc/sudoers.d/redmine && \
    chmod 0440 /etc/sudoers.d/redmine && \
    su - redmine -c "bundle config mirror.https://rubygems.org https://ruby.taobao.org"  && \
    su - redmine -c "bundle install --without development test"

RUN gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/ && \
    gem install thin && \
    thin config -C /srv/redmine/config/thin.yml -c /srv/redmine -e production \
        -l log/thin.log -P tmp/pids/thin.pid -u redmine -g docker \
        --max-conns 65535 --max-persistent-conns 512 && \
    sed -i -e '/daemonize:/s/ true/ false/' /srv/redmine/config/thin.yml && \
    echo "gem 'thin'" >> /srv/redmine/Gemfile.local

ADD src/etc/supervisord.conf /etc/

ADD src/srv/ /srv/
RUN cd /srv/up.d && \
    mv 00-gitolite.init 10-gitolite.init && \
    mv 01-gitolite.add-user 11-gitolite.add-user

