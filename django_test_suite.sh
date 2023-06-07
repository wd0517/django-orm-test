#!/bin/bash
# Copyright 2021 PingCAP, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# See the License for the specific language governing permissions and
# limitations under the License.

set -x pipefail

# Disable buffering, so that the logs stream through.
export PYTHONUNBUFFERED=1

mysql -h 127.0.0.1 -P 4000 -u root < init.sql

export DJANGO_TESTS_DIR="django_tests_dir"
mkdir -p $DJANGO_TESTS_DIR

pip3 install .
# git clone --depth 1  --branch $DJANGO_VERSION https://github.com/django/django.git $DJANGO_TESTS_DIR/django
cp tidb_settings.py $DJANGO_TESTS_DIR/django/tidb_settings.py
cp tidb_settings.py $DJANGO_TESTS_DIR/django/tests/tidb_settings.py

cd $DJANGO_TESTS_DIR/django && pip3 install -e . && pip3 install -r tests/requirements/py3.txt && pip3 install -r tests/requirements/mysql.txt; cd ../../
cd $DJANGO_TESTS_DIR/django/tests

python3 runtests.py $DJANGO_TEST_APPS --keepdb --noinput --settings tidb_settings
