FROM ubuntu:17.10

LABEL maintainer="malvarez00@icloud.com" \
	  version="0.1"

# Install motion, ffmpeg, v4l-utils and the dependencies from the repositories
RUN apt-get update && \
	apt-get -y upgrade &&\
	apt-get -y install \
		motion ffmpeg v4l-utils \
		python-pip \
		python-dev \
		curl \
		libssl-dev \
		libcurl4-openssl-dev \
		libjpeg-dev &&\
	apt-get clean

# Install motioneye, tornado, jinja2, pillow and pycurl
RUN pip install tornado jinja2 pillow pycurl

# Prepare the configuration directory
RUN mkdir -p /etc/motioneye \
	cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf		

# Prepare the media directory
RUN mkdir -p /var/lib/motioneye


# R/W needed for motioneye to update configurations
VOLUME /etc/motioneye

# Video & images
VOLUME /var/lib/motioneye

# Add an init script, configure it to run at startup and start the motionEye server
CMD cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service \
	systemctl daemon-reload \
	systemctl enable motioneye \
	systemctl start motioneye

EXPOSE 8765