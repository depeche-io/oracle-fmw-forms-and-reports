#!/bin/bash
#
#===============================================
# MUST: Customize this to your local env
#===============================================
#
# Directory where all domains/db data etc are 
# kept. Directories will be created here
export USERHOME=/u01/oracle

#===============================================
#HOSTNAME=`hostname -f`
export HOSTNAME=${HOSTNAME:-localhost}

#
# AdminServer Password
#
export DDIR_FR=${USERHOME}/user_projects
export SCRIPT_HOME=/opt/container-scripts
export INT_ORACLE_HOME=/u01/oracle
export WL_HOME=${INT_ORACLE_HOME}/wlserver
export WLST_HOME=${INT_ORACLE_HOME}/oracle_common/common/bin
export MW=${INT_ORACLE_HOME}
export DOMAIN_BASE=${DDIR_FR}/domains
export APPLICATION_BASE=${DDIR_FR}/applications
export APP_VZ=${APPLICATION_BASE}

# install forms true / false
export FORMS12C=${FORMS12C:-true}
export FADS12C=${FADS12C:-false}
# install reports true / false
export REPORTS12C=${REPORTS12C:-true}
# install OHS true / false
export WEBTIER12C=${WEBTIER12C:-true}
export OHS_COMPONENTNAME=ohs1
export OHS_LISTENPORT=7777
export OHS_SSLPORT=4443

# Domain specific
export TEMPLATE=${WL_HOME}/common/templates/wls/wls.jar
export DOMAIN_NAME=${DOMAIN_NAME:-FRTEST}

# AdminServer
export AS_NAME=${AS_NAME:-FRTESTAdminServer}
export ADM_USER=${ADM_USER:-weblogic}
export ADM_PWD=${ADM_PWD:-welcome1}

export ADMINPORT=${ADMINPORT:-7001}
export ADMINPORTSSL=7101
export AS_HOST=${AS_HOST:-localhost}

# Name and Port for the Forms Managed Server
export FORMS_MS_NAME=${FORMS_MS_NAME:-MS_FORMS}
export FORMS12C_MS_PORT=${FORMS12C_MS_PORT:-9001}

# Name and Port for the Reports Managed Server
export REPORTS_MS_NAME=${REPORTS_MS_NAME:-MS_REPORTS}
export REPORTS12C_MS_PORT=${REPORTS12C_MS_PORT:-9002}

# Move Reports Application into WLS_FORMS (true or false)
export REPORTS_IN_FORMS=false

# Reports Server Definitions
export REP_SERVER=${REP_SERVER:-true}
export REP_SERVER_NAME=${REP_SERVER_NAME:-repserver1}

# NodeManager
export NM_LISTENADDRESS=${NM_LISTENADDRESS:-localhost}
export NM_TYPE=SSL
export NM_PORT=5556
export NM_USERNAME=${NM_USERNAME:-nodemanager}
export NM_PWD=${NM_PWD:-welcome1}

# Repository Connect
export DBUSER=${DBUSER:-sys}
export DBPWD=${DBPWD:-Example123_}
export DBROLE=SYSDBA
export COMPONENTPWD=${COMPONENTPWD:-Example123_}
export SCHEMA_PREFIX=${DOMAIN_NAME}
export DB_HOST=${DB_HOST:-oradb}
export DB_PORT=${DB_PORT:-1521}
export DB_SERVICE=${DB_SERVICE:-orclpdb1}
export DB_OMF=false
export PWDFILE=/tmp/passwords.txt
