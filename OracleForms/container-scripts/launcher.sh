#!/bin/bash

if [ "$DEBUG_SLEEP" = "true" ]; then
        sleep 9999999 # use this for own experiments, otherwise comment this
else
	source /opt/container-scripts/setenv.sh && /opt/container-scripts/crDomain.sh
fi
