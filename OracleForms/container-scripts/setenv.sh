#!/bin/sh
#
#===============================================
# MUST: Customize this to your local env
#===============================================
#
# Directory where all domains/db data etc are 
# kept. Directories will be created here
export USERHOME=/u01/oracle

# Registry names where requisite standard images
# can be found
export REGISTRY_FR="localhost"
export REGISTRY_DB=

# Proxy Environment
#export http_proxy=""
#export https_proxy=""
#export no_proxy=""

#===============================================
#
#HOSTNAME=`hostname -f`
export HOSTNAME=localhost
#
# Used by Docker Compose from the env
# Oracle DB Parameters
#
export ORCL_PORT=1521
export ORCL_OEM_PORT=5500
#ORCL_SID=frdb
#ORCL_PDB=frpdb
export ORCL_SID=orclpdb1
export ORCL_PDB=orclpdb1
#ORCL_SYSPWD=Oracle12c
export ORCL_SYSPWD=Tester123_
export ORCL_HOST=${HOSTNAME}
#
export ORCL_DBDATA=${USERHOME}/oradata
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
export FORMS12C=true
export FADS12C=false
# install reports true / false
export REPORTS12C=true
# install OHS true / false
export WEBTIER12C=true
export OHS_COMPONENTNAME=ohs1
export OHS_LISTENPORT=7777
export OHS_SSLPORT=4443

# Domain specific
export TEMPLATE=${WL_HOME}/common/templates/wls/wls.jar
export DOMAIN_NAME=FRTEST

# AdminServer
export AS_NAME=FRTESTAdminServer
export ADM_USER=weblogic
export ADM_PWD=welcome1
export ADMINPORT=7001
export ADMINPORTSSL=7101
export AS_HOST=localhost

# Name and Port for the Forms Managed Server
export FORMS_MS_NAME=MS_FORMS
export FORMS12C_MS_PORT=9001

# Name and Port for the Reports Managed Server
export REPORTS_MS_NAME=MS_REPORTS
export REPORTS12C_MS_PORT=9002

# Move Reports Application into WLS_FORMS (true or false)
export REPORTS_IN_FORMS=false

# Reports Server Definitions
export REP_SERVER=true
export REP_SERVER_NAME=repserver1

# NodeManager
export NM_LISTENADDRESS=localhost
export NM_TYPE=SSL
export NM_PORT=5556
export NM_USERNAME=nodemanager
export NM_PWD=welcome1

# Repository Connect
export DBUSER=sys
export DBPWD=Tester123_
export DBROLE=SYSDBA
export COMPONENTPWD=Tester123_
export SCHEMA_PREFIX=${DOMAIN_NAME}
export DB_HOST=oradb
export DB_PORT=${ORCL_PORT}
export DB_SERVICE=${ORCL_PDB}
export DB_OMF=false
export DB_USER_PW=Tester123_
export PWDFILE=/tmp/passwords.txt

#
# Default version to use for compose images
#
export FR_VERSION=12.2.1.4
