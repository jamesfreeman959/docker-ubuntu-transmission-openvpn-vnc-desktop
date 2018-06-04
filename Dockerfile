FROM ubuntu:16.04
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

#RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

#VOLUME /config

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl wget git \
    && sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list" \
    && curl -SL http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | apt-key add - \
    && add-apt-repository ppa:fcwu-tw/ppa \
    && add-apt-repository ppa:transmissionbt/ppa \
    && wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add - \
    && echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" > /etc/apt/sources.list.d/openvpn-aptrepo.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        fonts-wqy-microhei \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils wget rsync less vim dnsutils \
    && apt-get install -y sudo transmission-cli transmission-common transmission-daemon curl rar unrar zip unzip ufw iputils-ping openvpn \
       python2.7 python2.7-pysqlite2 transmission-gtk transmission-qt \
     && ln -sf /usr/bin/python2.7 /usr/bin/python2 \
    && wget https://github.com/Secretmapper/combustion/archive/release.zip \
    && unzip release.zip -d /opt/transmission-ui/ \
    && rm release.zip \
    && git clone git://github.com/endor/kettu.git /opt/transmission-ui/kettu \
    && sed -i 's/^IPV6=yes/IPV6=no/g' /etc/default/ufw \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && groupmod -g 1000 users \
    && useradd -u 911 -U -d /config -s /bin/bash abc \
    && usermod -G users abc


# tini for subreap                                   
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install --upgrade pip==9.0.3 && pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

ENV OPENVPN_USERNAME=**None** \
    OPENVPN_PASSWORD=**None** \
    OPENVPN_PROVIDER=**None** 

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
