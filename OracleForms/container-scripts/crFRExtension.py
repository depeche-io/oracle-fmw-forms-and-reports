#!/usr/bin/python

# Things to do:
#

import os, sys
v_forms=os.environ['FORMS12C']
v_formsMSName=os.environ['FORMS_MS_NAME']
v_formsPort=os.environ['FORMS12C_MS_PORT']
v_fads=os.environ['FADS12C']
v_reports=os.environ['REPORTS12C']
v_reportsMSName=os.environ['REPORTS_MS_NAME']
v_reportsPort=os.environ['REPORTS12C_MS_PORT']
v_NMListenAddress=os.environ['NM_LISTENADDRESS']
v_NMType=os.environ['NM_TYPE']
v_NMPort=os.environ['NM_PORT']
v_NMUsername=os.environ['NM_USERNAME']
v_NMPwd=os.environ['NM_PWD']
v_domain=os.environ['DOMAIN_NAME']

if 'DB_CONNECT_STRING' in os.environ:
   v_url="jdbc:oracle:thin:@" + os.environ['DB_CONNECT_STRING']
else:
   v_dbhost=os.environ['DB_HOST']
   v_dbport=os.environ['DB_PORT']
   v_dbservice=os.environ['DB_SERVICE']
   v_url="jdbc:oracle:thin:@//"+v_dbhost+':'+v_dbport+'/'+v_dbservice

v_pwd=os.environ['COMPONENTPWD']
v_SchemaPrefix=os.environ['SCHEMA_PREFIX']
v_setup_domain_base=os.environ['DOMAIN_BASE']
v_setup_application_base=os.environ['APPLICATION_BASE']
v_reports_in_forms=os.environ['REPORTS_IN_FORMS']
v_asName=os.environ['AS_NAME']

if v_fads == "true":
   v_asName="AdminServer"

def changeDatasourceToXA(datasource):
  print 'Change datasource '+datasource
  cd('/')
  cd('/JDBCSystemResource/'+datasource+'/JdbcResource/'+datasource+'/JDBCDriverParams/NO_NAME_0')
  set('DriverName','oracle.jdbc.xa.client.OracleXADataSource')
  set('UseXADataSourceInterface','True')
  cd('/JDBCSystemResource/'+datasource+'/JdbcResource/'+datasource+'/JDBCDataSourceParams/NO_NAME_0')
  set('GlobalTransactionsProtocol','TwoPhaseCommit')
  cd('/')

def printHeader(headerText):
    print "\n======================================================================================"
    print "--> "+headerText
    print "======================================================================================\n"

def printInfo(infoText):
    print "-->: "+infoText

printHeader("Started: crFRExtension.py")

try:
    if not ( v_forms == "true" or v_reports == "true" ):
       printInfo( "Forms and Reports flag are set to false")
       printInfo( "We will stop processing, please activate Forms or Reports")
       exit()
    printHeader( "readDomain "+v_domain+" started")
    readDomain(v_setup_domain_base+'/'+v_domain)
    printInfo( "readDomain successful")
except:
    printInfo( "readDomain failed")
    exit()

try:
    printHeader( "select and load templates")
    selectTemplate('Oracle HTTP Server (Collocated)')
    if v_forms == "true":
       if v_fads == "true":
          selectTemplate('Oracle Forms')
          selectTemplate('Oracle WSM Policy Manager')
          selectTemplate('Oracle Forms Application Deployment Service (FADS)','12.2.1.3.0')
       else:
          selectTemplate('Oracle Forms')
    if v_reports == "true":
       selectTemplate('Oracle Reports Application')
       selectTemplate('Oracle Reports Server')
    printInfo( "select templates successful")
    loadTemplates()
    printInfo( "load templates successful")
except:
    printInfo( "select and load templates failed")
    dumpStack()
    exit()

printHeader("JDBC configuration")
try:
    printInfo("Configure LocalSvcTblDataSource")
    cd('/')
    cd('/JDBCSystemResource/LocalSvcTblDataSource/JdbcResource/LocalSvcTblDataSource')
    cd('JDBCDriverParams/NO_NAME_0')
    set('DriverName','oracle.jdbc.OracleDriver')
    set('URL', v_url)
    set('PasswordEncrypted', v_pwd)
    cd('Properties/NO_NAME_0')
    cd('Property/user')
    cmo.setValue(v_SchemaPrefix+'_STB')
    printInfo("Configure LocalSvcTblDataSource successful")
except:
    printInfo("Configure LocalSvcTblDataSource failed")
    exit()

try:
    printInfo("Configure opss-data-source")
    cd('/')
    cd('JDBCSystemResource/opss-data-source/JdbcResource/opss-data-source')
    cd('JDBCDriverParams/NO_NAME_0')
    set('DriverName','oracle.jdbc.OracleDriver')
    set('URL', v_url)
    set('PasswordEncrypted', v_pwd)
    cd('Properties/NO_NAME_0')
    cd('Property/user')
    cmo.setValue(v_SchemaPrefix+'_OPSS')
    printInfo("Configure opss-data-source successful")
except:
    printInfo("Configure opss-data-source failed")
    exit()

try:
    printInfo("Configure opss-audit-viewDS")
    cd('/')
    cd('JDBCSystemResource/opss-audit-viewDS/JdbcResource/opss-audit-viewDS')
    cd('JDBCDriverParams/NO_NAME_0')
    set('DriverName','oracle.jdbc.OracleDriver')
    set('URL', v_url)
    set('PasswordEncrypted', v_pwd)
    cd('Properties/NO_NAME_0')
    cd('Property/user')
    cmo.setValue(v_SchemaPrefix+'_IAU_VIEWER')
    printInfo("Configure opss-audit-viewDS successful")
except:
    printInfo("Configure opss-audit-viewDS failed")
    exit()

try:
    printInfo("Configure opss-audit-DBDS")
    cd('/')
    cd('JDBCSystemResource/opss-audit-DBDS/JdbcResource/opss-audit-DBDS')
    cd('JDBCDriverParams/NO_NAME_0')
    set('DriverName','oracle.jdbc.OracleDriver')
    set('URL', v_url)
    set('PasswordEncrypted', v_pwd)
    cd('Properties/NO_NAME_0')
    cd('Property/user')
    cmo.setValue(v_SchemaPrefix+'_IAU_APPEND')
    printInfo("Configure opss-audit-DBDS successful")
except:
    printInfo("Configure opss-audit-DBDS failed")
    exit()

try:
    if v_fads == "true":
       printInfo("Configure mds-owsm")
       cd('/')
       cd('JDBCSystemResource/mds-owsm/JdbcResource/mds-owsm')
       cd('JDBCDriverParams/NO_NAME_0')
       set('DriverName','oracle.jdbc.OracleDriver')
       set('URL', v_url)
       set('PasswordEncrypted', v_pwd)
       cd('Properties/NO_NAME_0')
       cd('Property/user')
       cmo.setValue(v_SchemaPrefix+'_MDS')
       printInfo("Configure mds-owsm successful")
except:
    printInfo("Configure mds-owsm failed")
    exit()

try:
   printInfo("Modify Datasources: LocalSvcTblDataSource , opss-audit-DBDS, opss-audit-viewDS , opss-data-source")
   changeDatasourceToXA('LocalSvcTblDataSource')
   changeDatasourceToXA('opss-audit-DBDS')
   changeDatasourceToXA('opss-audit-viewDS')
   changeDatasourceToXA('opss-data-source')
   #if v_fads == "true":
   #   printInfo("Modify Datasource mds-owsm for FADS")
   #   changeDatasourceToXA('mds-owsm')
   printInfo("Modify Datasources successful")
except:
   printInfo("Modify Datasources failed")

if v_fads == "true":
   printHeader('Setting Server Group WSMPM-MAN-SVR for FADS in ' +v_asName)
   cd('/')
   serverGroup = ['JRF-MAN-SVR','WSMPM-MAN-SVR']
   setServerGroups(v_asName, serverGroup) 

printHeader('Customize Domain Settings')
try:
    printInfo("Name and Ports of the Managed Servers will be modified")
    if v_forms == "true":
       cd('/')
       cd('/Server/WLS_FORMS')
       cmo.setName(v_formsMSName)
       cd('/')
       cd('/Server/'+v_formsMSName)
       cmo.setListenPort(int(v_formsPort))
    if v_reports == "true":
       cd('/')
       cd('/Server/WLS_REPORTS')
       cmo.setName(v_reportsMSName)
       cd('/Server/'+v_reportsMSName)
       cmo.setListenPort(int(v_reportsPort))
    printInfo("Modification of Name and Ports are successful")
except:
    printInfo("ERROR: Modification of Name and Ports are failed")

try:
    if v_reports_in_forms == 'false':
        printInfo("Reports are remaining in own Managed Server")
except:
    printInfo("x")

try:
    if v_reports_in_forms == 'true':
        printInfo("Trying Move Reports into Forms Managed Server")
        cd('/')
        cd('/AppDeployments/reports#12.2.1')
        set('Target','cluster_forms')
        cd('/')
        cd('/Library/oracle.reports.applib#12.2.1@12.2.1')
        set('Target','cluster_forms')
        printInfo("Move Reports into Forms Managed Server are successful")
except:
    printInfo("ERROR: Move Reports into Forms Managed Server failed")

try:
    printHeader("Nodemanager Configuration")
    cd('/')
    cd('/Machines/AdminServerMachine/NodeManager/AdminServerMachine')
    cmo.setNMType(v_NMType)
    cmo.setListenAddress(v_NMListenAddress)
    cmo.setListenPort(int(v_NMPort))
    cd('/')
    cd('/SecurityConfiguration/'+v_domain)
    cmo.setNodeManagerUsername(v_NMUsername)
    cmo.setNodeManagerPasswordEncrypted(v_NMPwd)
    printInfo("Nodemanager Configuration successful")
except:
    printInfo("ERROR: Nodemanager Configuration failed")

try:
    printHeader("AppDir will be set to "+v_setup_application_base+"/"+v_domain)
    try:
        setOption('AppDir',v_setup_application_base+"/"+v_domain)
    except Exception, e:
        print "Error Message "+ str(e)

    printInfo("Domain will be updated and saved")
    printInfo("... this can take up to 5 minutes")
    updateDomain()
    closeDomain()
    printHeader("Program End: crFRExtension.py")

#    exit()
except:
   print "Domain could not be saved"
   dumpStack()

try:
    printHeader("Admin Server will be assigned to Machine")
    readDomain(v_setup_domain_base+'/'+v_domain)
    printInfo( "readDomain successful")
    cd('Servers/'+v_asName)
    set('Machine','AdminServerMachine')
    printInfo("Domain will be updated and saved")
    printInfo("... this can take up to 5 minutes")
    updateDomain()
    closeDomain()
#    exit()
except:
    printInfo( "readDomain failed")
    exit()

try:
    printHeader("Admin Server will be assigned to Machine")
    readDomain(v_setup_domain_base+'/'+v_domain)
    printInfo( "read Domain successful")
    cd('Servers/'+v_asName)
    set('Machine','AdminServerMachine')
    printInfo("Domain will be updated and saved")
    printInfo("... this can take up to 5 minutes")
    updateDomain()
    closeDomain()
    print "======================================================================================"
    exit()
except:
    printInfo( "readDomain failed")
    exit()

