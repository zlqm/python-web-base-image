#!/bin/bash
readonly PWD=$(dirname $(readlink -f $0))
readonly IMAGE="python-web-base:latest"
readonly CONTIANER_NAME="python-web-test"

function start_container(){
	docker run --rm \
		-p 8000:8000 \
		-v "$PWD/conf/runit/web_app.sh:/etc/service/web/run:ro" \
		-v "$PWD/conf/nginx/sites-enabled:/etc/nginx/sites-enabled:ro" \
		$IMAGE
}

function check_server(){
	server_name=$(curl -I -s http://localhost:8000 |grep -i server)
	if [[ -z $(echo $server_name |grep -i python) ]]; then
		echo "HTTP Response Header Server should contain python"
		exit 1
	else
		echo "ok"
	fi
}


case "$1" in 
	start)
		start_container
		;;
	check)
		check_server
		;;
	*)
		echo "Usage: $0 {start|check}"
		;;
esac

