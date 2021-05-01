FROM ubuntu:20.04

#ENV PIP_NO_CACHE_DIR off
#ENV PIP_DISABLE_PIP_VERSION_CHECK on
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND="noninteractive"

RUN set -ex; \
  apt-get update; \
  apt-get install -y python3 python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev ; \
  # cleaning up unused files \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

RUN pip3 install -U twisted==21.2.0 scrapyd==1.2.1

ARG USER_ID=1001
ARG GROUP_ID=1001

RUN set -ex; \
  addgroup --gid $GROUP_ID --system scrapyd; \
  adduser --system --uid $USER_ID --gid $GROUP_ID scrapyd

EXPOSE 6800

VOLUME ["/var/log/scrapyd/", "/var/lib/scrapyd/"]

#RUN set -ex; \
#    mkdir /etc/scrapyd/
#COPY scrapyd.conf /etc/scrapyd/scrapyd.conf

USER scrapyd

CMD scrapyd