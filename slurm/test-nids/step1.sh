#!/bin/bash

end=$((SECONDS+5))

while [ $SECONDS -lt $end ]; do
    # Do what you want.
    echo "Jobstep 1: +`hostname -A`"
    sleep 5
done
