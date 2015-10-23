#!/bin/bash
set -e

printf "$KEY_VALUE" > /etc/mongod-keyfile
printf "security:\n  keyFile: /etc/mongod-keyfile" > /etc/mongod.conf

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

if [ "$1" = 'mongod' ]; then
	chown -R mongodb /data/db

	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi

	exec gosu mongodb "$@"
fi

exec "$@"
