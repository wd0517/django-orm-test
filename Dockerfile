FROM python:3.11
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        default-libmysqlclient-dev \
        default-mysql-client \
        wget \
    && apt-get clean \
    && apt-get remove --purge --auto-remove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src/app

RUN wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz \
    && rm -rf go1.20.5.darwin-arm64.tar.gz

COPY ./requirements.txt /usr/src/app
RUN pip install -r /usr/src/app/requirements.txt

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -g ${gid} ${group} \
    && useradd -d "/home/${user}" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN mkdir -p /home/jenkins/

ENV HOME /home/${user}
ENV PATH=$PATH:/home/jenkins/.local/bin:/usr/local/go/bin

USER ${user}
WORKDIR /home/${user}
