#!/bin/bash
source /opt/container-scripts/setenv.sh

if [ -z "${WLST_HOME}" ]; then
    echo "Environment not correctly set - please verify"
    exit 1
fi

# Docker Hack, if Domain is already created (first run), we will be here
# and can startup the Forms & Reports Domain
# In case we are facing problems with /dev/random
export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS
# Avoiding MDS-11019 error messages
export JAVA_OPTIONS="${JAVA_OPTIONS} -Dfile.encoding=UTF8"
# Startup the Node Manager and AdminServer

nohup ${DOMAIN_BASE}/InfraDomain/bin/startNodeManager.sh > /dev/null 2>&1 &
echo "Wait 30 seconds for Node Manager to start ..."
sleep 30
${DOMAIN_BASE}/InfraDomain/startWebLogic.sh
