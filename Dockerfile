FROM ubuntu:12.04

# Install apache
RUN apt-get update &&\
    RUNLEVEL=1 apt-get -y install\
        apache2 \
        apache2-mpm-prefork \
        sendmail \
    &&\
    a2enmod rewrite &&\
    rm /etc/apache2/sites-enabled/000-default

# Download an build PHP 5.2.17
# See https://askubuntu.com/questions/597462/how-to-install-php-5-2-x-on-ubuntu-14-04
RUN mkdir /php;\
    cd /php; \
    apt-get -y --no-install-recommends install \
        wget \
        tar \
        bzip2 \
        gcc \
        make \
        build-essential \
        libcurl4-openssl-dev \
        libxml2-dev \
        libbz2-dev \
        libmcrypt-dev \
        libmhash-dev \
        libncurses-dev \
        libpspell-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libt1-dev \
        libc-client-dev \
        libmysqlclient-dev \
        libltdl-dev \
        libreadline-dev \
        apache2-prefork-dev \
        libgdbm-dev \
        autoconf \
        libmagic-dev \
    && \
    wget http://museum.php.net/php5/php-5.2.17.tar.bz2 && \
    tar xfj php-5.2.17.tar.bz2 && \
    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.* /usr/lib/; \
    ln -s /usr/lib/x86_64-linux-gnu/libpng.* /usr/lib/; \
    ln -s /usr/lib/x86_64-linux-gnu/libkrb5.* /usr/lib/; \
    ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.* /usr/lib/; \
    cd php-5.2.17; \
    wget -c -t 3 -O ./debian_patches_disable_SSLv2_for_openssl_1_0_0.patch https://bugs.php.net/patch-display.php\?bug_id\=54736\&patch\=debian_patches_disable_SSLv2_for_openssl_1_0_0.patch\&revision=1305414559\&download\=1 && \
    patch -p1 -b < debian_patches_disable_SSLv2_for_openssl_1_0_0.patch && \
    
    # Build apache module
    ./configure \
        --bindir=/usr/bin \
        --sbindir=/usr/sbin \
        --prefix=/usr \
        --build=i686-pc-linux-gnu \
        --host=i686-pc-linux-gnu \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --datadir=/usr/share \
        --sysconfdir=/etc \
        --localstatedir=/var/lib \
        --prefix=/usr/lib/php5.2 \
        --mandir=/usr/lib/php5.2/man \
        --infodir=/usr/lib/php5.2/info \
        --libdir=/usr/lib/php5.2/lib \
        --with-libdir=lib \
        --with-pear \
        --disable-maintainer-zts \
        --enable-bcmath \
        --with-bz2 \
        --enable-calendar \
        --with-curl \
        --with-curlwrappers \
        --disable-dbase \
        --enable-exif \
        --without-fbsql \
        --without-fdftk \
        --enable-ftp \
        --with-gettext \
        --without-gmp \
        --disable-ipv6 \
        --with-kerberos \
        --enable-mbstring \
        --with-mcrypt \
        --with-mhash \
        --without-msql \
        --without-mssql \
        --with-ncurses \
        --with-openssl \
        --with-openssl-dir=/usr \
        --disable-pcntl \
        --without-pgsql \
        --with-pspell \
        --without-recode \
        --disable-shmop \
        --without-snmp \
        --enable-soap \
        --enable-sockets \
        --without-sybase-ct \
        --disable-sysvmsg \
        --disable-sysvsem \
        --disable-sysvshm \
        --without-tidy \
        --disable-wddx \
        --disable-xmlreader \
        --disable-xmlwriter \
        --with-xmlrpc \
        --without-xsl \
        --enable-zip \
        --with-zlib \
        --disable-debug \
        --enable-dba \
        --without-cdb \
        --disable-flatfile \
        --with-gdbm \
        --disable-inifile \
        --without-qdbm \
        --with-freetype-dir=/usr \
        --with-t1lib=/usr \
        --disable-gd-jis-conv \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --without-xpm-dir \
        --with-gd \
        --with-imap \
        --with-imap-ssl \
        --without-interbase \
        --with-mysql=/usr \
        --with-mysqli=/usr/bin/mysql_config \
        --without-oci8 \
        --without-pdo-dblib \
        --with-pdo-mysql=/usr \
        --without-pdo-pgsql \
        --without-pdo-sqlite \
        --without-pdo-odbc \
        --with-readline \
        --without-libedit \
        --without-mm \
        --without-sqlite \
        --with-pcre-regex \
        --with-config-file-path=/etc/php/apache2-php5.2 \
        --with-config-file-scan-dir=/etc/php/apache2-php5.2/ext-active \
        --disable-cli \
        --disable-cgi \
        --disable-embed \
        --with-apxs2=/usr/bin/apxs2 \
        --with-pic \
    && \
    make && \
    make install && \
    
    # Build cli
    ./configure \
        --bindir=/usr/bin \
        --sbindir=/usr/sbin \
        --prefix=/usr \
        --build=i686-pc-linux-gnu \
        --host=i686-pc-linux-gnu \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --datadir=/usr/share \
        --sysconfdir=/etc \
        --localstatedir=/var/lib \
        --prefix=/usr/lib/php5.2 \
        --mandir=/usr/lib/php5.2/man \
        --infodir=/usr/lib/php5.2/info \
        --libdir=/usr/lib/php5.2/lib \
        --with-libdir=lib \
        --with-pear \
        --disable-maintainer-zts \
        --enable-bcmath \
        --with-bz2 \
        --enable-calendar \
        --with-curl \
        --with-curlwrappers \
        --disable-dbase \
        --enable-exif \
        --without-fbsql \
        --without-fdftk \
        --enable-ftp \
        --with-gettext \
        --without-gmp \
        --disable-ipv6 \
        --with-kerberos \
        --enable-mbstring \
        --with-mcrypt \
        --with-mhash \
        --without-msql \
        --without-mssql \
        --with-ncurses \
        --with-openssl \
        --with-openssl-dir=/usr \
        --disable-pcntl \
        --without-pgsql \
        --with-pspell \
        --without-recode \
        --disable-shmop \
        --without-snmp \
        --enable-soap \
        --enable-sockets \
        --without-sybase-ct \
        --disable-sysvmsg \
        --disable-sysvsem \
        --disable-sysvshm \
        --without-tidy \
        --disable-wddx \
        --disable-xmlreader \
        --disable-xmlwriter \
        --with-xmlrpc \
        --without-xsl \
        --enable-zip \
        --with-zlib \
        --disable-debug \
        --enable-dba \
        --without-cdb \
        --disable-flatfile \
        --with-gdbm \
        --disable-inifile \
        --without-qdbm \
        --with-freetype-dir=/usr \
        --with-t1lib=/usr \
        --disable-gd-jis-conv \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --without-xpm-dir \
        --with-gd \
        --with-imap \
        --with-imap-ssl \
        --without-interbase \
        --with-mysql=/usr \
        --with-mysqli=/usr/bin/mysql_config \
        --without-oci8 \
        --without-pdo-dblib \
        --with-pdo-mysql=/usr \
        --without-pdo-pgsql \
        --without-pdo-sqlite \
        --without-pdo-odbc \
        --with-readline \
        --without-libedit \
        --without-mm \
        --without-sqlite \
        --with-pcre-regex \
        --with-config-file-path=/etc/php/cli-php5.2 \
        --with-config-file-scan-dir=/etc/php/cli-php5.2/ext-active \
        --enable-cli \
        --disable-cgi \
        --disable-embed \
        --with-pic \
    && \
    make clean && \
    make && \
    make install && \

    # Add extensions
    pecl install Fileinfo && \
    pecl install memcache && \
    cd /php && \
    wget http://downloads.zend.com/optimizer/3.3.3/ZendOptimizer-3.3.3-linux-glibc23-x86_64.tar.gz && \
    tar xzf ZendOptimizer-3.3.3-linux-glibc23-x86_64.tar.gz && \
    mkdir /usr/lib/php5.2/modules && \
    cp ZendOptimizer-3.3.3-linux-glibc23-x86_64/data/5_2_x_comp/ZendOptimizer.so /usr/lib/php5.2/modules/ && \

    # Clean up
    rm -Rf /php && \
    apt-get -y remove \
        wget \
        bzip2 \
        gcc \
        make \
        build-essential \
        libcurl4-openssl-dev \
        libxml2-dev \
        libbz2-dev \
        libmcrypt-dev \
        libmhash-dev \
        libncurses-dev \
        libpspell-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libt1-dev \
        libc-client-dev \
        libmysqlclient-dev \
        libltdl-dev \
        libreadline-dev \
        apache2-prefork-dev \
        libgdbm-dev \
        autoconf \
        libmagic-dev \
    && \
    apt-get clean

COPY 000-project.conf /etc/apache2/sites-enabled/
COPY php.ini /etc/php/apache2-php5.2/
COPY php.ini /etc/php/cli-php5.2/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
