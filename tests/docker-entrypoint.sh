#!/bin/bash

set -e

if [ "$1" = "tests" ]; then
	shift

	# Waiting for the test server to come online...
	while ! nc webdav 80 ; do
		echo "Waiting for webserver to come up..."
		sleep 1
	done

	# Generate some test files
	dd if=/dev/zero of=/tmp/zero.bin bs=64k count=1 2>/dev/null
	dd if=/dev/random of=/tmp/random.bin bs=64k count=1 2>/dev/null

	# Change execution control into the python script, no buffering for output.
	MODULE=$1
	shift
	exec /usr/bin/python3 -u -m unittest -v /app/tests_${MODULE}.py "$@"
fi

exec "$@"
