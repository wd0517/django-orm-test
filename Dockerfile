FROM python:3.11
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        default-libmysqlclient-dev \
        default-mysql-client \
    && apt-get clean \
    && apt-get remove --purge --auto-remove -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src/app
COPY ./requirements.txt /usr/src/app
RUN pip install -r /usr/src/app/requirements.txt -i https://pypi.douban.com/simple/

RUN mkdir -p /home/jenkins/app
WORKDIR /home/jenkins/app