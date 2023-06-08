#!/bin/bash
set +x

echo "django orm test start"

DJANGO_TIDB_LOG="tidb_django.log"

# start tidb servers
echo "starting tidb-servers, log file: ${DJANGO_TIDB_LOG}"
${TIDB_SERVER_PATH} -config tidb_config.toml -store unistore -path "" -lease 0s > ${DJANGO_TIDB_LOG} 2>&1 &
SERVER_PID=$!
sleep 5
echo "tidb-server(PID: ${SERVER_PID}) started"

# when exit clean
trap 'kill ${SERVER_PID}' EXIT

echo "loading test data to db ..."
mysql -u root -h 127.0.0.1 -P 4001 < init.sql


# start test
TIDB_PORT=4001 python run_testing_worker.py
EXIT_CODE=$?


# handle test results
if [ ${EXIT_CODE} -ne 0 ]
then
	echo "ERROR: django test failed!"
	echo "=========== ERROR EXIT [${EXIT_CODE}]: FULL tidb.log BEGIN ============"
	cat ${DJANGO_TIDB_LOG}
	echo "=========== ERROR EXIT [${EXIT_CODE}]: FULL tidb.log END =============="
	exit 1
fi