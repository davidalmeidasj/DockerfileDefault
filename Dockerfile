FROM ubuntu:16.04

MAINTAINER David Almeida <davidasj21@gmail.com>

# update apt-get
RUN apt-get update

# install php, git, nginx
RUN apt-get install -y php7.0 php7.0-cli php7.0-json php7.0-mbstring php7.0-mysql php7.0-xml php7.0-fpm php7.0-cgi php7.0-soap php-xml git nginx zsh zip unzip php7.0-curl software-properties-common php-dev wget

# install composer
RUN apt-get install -y curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# create user
RUN useradd -ms /bin/bash user-facul

# install and configure xdebug
RUN wget -O xdebug-2.4.0.tgz http://xdebug.org/files/xdebug-2.4.0.tgz
RUN tar -xvf xdebug-2.4.0.tgz
WORKDIR /xdebug-2.4.0
RUN phpize && ./configure && make
RUN cp modules/xdebug.so /usr/lib/php/20151012
RUN echo "zend_extension = /usr/lib/php/20151012/xdebug.so" >> /etc/php/7.0/cli/php.ini
RUN echo "zend_extension = /usr/lib/php/20151012/xdebug.so" >> /etc/php/7.0/fpm/php.ini

# install node and apidoc
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash

#install node 6.3.1
RUN . ~/.nvm/nvm.sh && nvm install 6.3.1 && nvm alias default 6.3.1
#set node and npm in PATH
ENV PATH /bin/versions/node/v6.3.1/bin/:/bin/versions/node/v6.3.1/lib/node_modules/npm/bin/:${PATH}
RUN echo "PATH=\"/bin/versions/node/v6.3.1/bin/:/bin/versions/node/v6.3.1/lib/node_modules/npm/bin/:${PATH}\"" >> /home/user-facul/.bashrc

# install apidoc
RUN npm install apidoc -g

# install commitizen
RUN npm install -g commitizen
RUN echo '{ "path": "cz-conventional-changelog" }' > /home/user-facul/.czrc

# install fish shell
RUN apt-add-repository ppa:fish-shell/release-2
RUN apt-get update
RUN apt-get -y install fish

WORKDIR /
