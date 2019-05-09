#!/bin/sh

echo "Sidecar running"
echo "pid is $$"


# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
