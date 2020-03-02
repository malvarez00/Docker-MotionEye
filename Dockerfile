# MotionEye

FROM lsiobase/ubuntu

LABEL maintainer="malvarez00@icloud.com"
ARG VERSION=0.42

# Environment Settings
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --quiet --yes update

RUN apt-get --quiet --yes install motion \
                                  ffmpeg \
                                  v4l-utils

RUN apt-get --quiet --yes install python-pip \
                                  python-dev \
                                  curl \
                                  libssl-dev \
                                  libcurl4-openssl-dev \
                                  libjpeg-dev

RUN pip install --upgrade pip
RUN pip install motioneye

RUN apt-get --quiet autoremove --yes && \
    apt-get --quiet --yes clean

# Prepare the configuration directory
RUN mkdir -p /etc/motioneye
RUN cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf

# Prepare the media directory
RUN mkdir -p /var/lib/motioneye

RUN cp /usr/local/share/motioneye/extra/motioneye.init-debian /etc/init.d/motioneye
RUN chmod +x /etc/init.d/motioneye
RUN update-rc.d -f motioneye defaults
RUN /etc/init.d/motioneye start

CMD tail -f /dev/null

# R/W needed for motioneye to update configurations
VOLUME /etc/motioneye

# Video & images
VOLUME /var/lib/motioneye

EXPOSE 8765
