SET VERIFY OFF;

CREATE  TABLESPACE "INFRADOMAIN_IAS_OPSS" EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  SEGMENT SPACE MANAGEMENT  AUTO  DATAFILE '/oradata/DGALOB/INFRADOMAIN_ias_opss.dbf' SIZE 60M REUSE  AUTOEXTEND ON  MAXSIZE  UNLIMITED  ;

CREATE  TABLESPACE "INFRADOMAIN_IAS_UMS" EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  SEGMENT SPACE MANAGEMENT  AUTO  DATAFILE '/oradata/DGALOB/INFRADOMAIN_UMS.dbf' SIZE 100M REUSE  AUTOEXTEND ON  NEXT 30M MAXSIZE  UNLIMITED  ;

CREATE  TABLESPACE "INFRADOMAIN_IAU" EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  SEGMENT SPACE MANAGEMENT  AUTO  DATAFILE '/oradata/DGALOB/INFRADOMAIN_iau.dbf' SIZE 60M REUSE  AUTOEXTEND ON  MAXSIZE  UNLIMITED  ;

CREATE  TABLESPACE "INFRADOMAIN_MDS" EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  SEGMENT SPACE MANAGEMENT  AUTO  DATAFILE '/oradata/DGALOB/INFRADOMAIN_mds.dbf' SIZE 100M REUSE  AUTOEXTEND ON  NEXT 50M MAXSIZE  UNLIMITED  ;

CREATE  TABLESPACE "INFRADOMAIN_STB" EXTENT MANAGEMENT LOCAL  AUTOALLOCATE  SEGMENT SPACE MANAGEMENT  AUTO  DATAFILE '/oradata/DGALOB/INFRADOMAIN_svctbl.dbf' SIZE 10M REUSE  AUTOEXTEND ON  NEXT 2M MAXSIZE  UNLIMITED  ;

---------------------------------------------------------
---------- STB(Common Infrastructure Services) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='STB';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''STB'', ''Service Table'', ''INFRADOMAIN'', ''STB'', ''STB'', ''INFRADOMAIN_STB'', ''12.2.1.3.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_STB : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_STB IDENTIFIED BY &SCHEMA_PASSWORD DEFAULT TABLESPACE INFRADOMAIN_STB TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP'; 
end;

/

GRANT connect TO INFRADOMAIN_STB
/

GRANT create table TO INFRADOMAIN_STB
/

GRANT select on schema_version_registry to INFRADOMAIN_STB
/

ALTER USER INFRADOMAIN_STB QUOTA unlimited ON INFRADOMAIN_STB
/

DECLARE
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE STBROLE';
EXCEPTION
    WHEN OTHERS THEN  NULL;
END;

/

SET ECHO ON
/

SET FEEDBACK 1
/

SET NUMWIDTH 10
/

SET LINESIZE 80
/

SET TRIMSPOOL ON
/

SET TAB OFF
/

SET PAGESIZE 100
/

ALTER SESSION SET CURRENT_SCHEMA=INFRADOMAIN_STB
/

CREATE TABLE "COMPONENT_SCHEMA_INFO"
(
  "SCHEMA_USER"     VARCHAR2(100) NOT NULL,
  "SCHEMA_PASSWORD" BLOB ,
  "COMP_ID" VARCHAR2(100) NOT NULL,
  "PREFIX_NAME"     VARCHAR2(100) ,
  "DB_HOSTNAME"     VARCHAR2(255) ,
  "DB_SERVICE"      VARCHAR2(200) ,
  "DB_PORTNUMBER"   VARCHAR2(10),
  "DATABASE_NAME"   VARCHAR2(200),
  "STATUS"          VARCHAR2(20),  
  "URL"             VARCHAR2(4000),
  "CONNPROPS" BLOB  
) tablespace INFRADOMAIN_STB
/

CREATE INDEX COMPONENT_SCHEMA_INFO_IDX ON COMPONENT_SCHEMA_INFO(SCHEMA_USER)
/


GRANT SELECT, INSERT, UPDATE, DELETE ON INFRADOMAIN_STB.COMPONENT_SCHEMA_INFO TO STBROLE

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''STB'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_STB
/

COMMIT
/

---------------------------------------------------------
---------- STB(Common Infrastructure Services) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- IAU_APPEND(Audit Services Append) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='IAU_APPEND';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''IAU_APPEND'', ''Audit Service Append'', ''INFRADOMAIN'', ''IAU_APPEND'', ''IAU_APPEND'', ''INFRADOMAIN_IAU_APPEND'', ''12.2.1.2.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

SET ECHO ON
/

SET FEEDBACK 1
/

SET NUMWIDTH 10
/

SET LINESIZE 80
/

SET TRIMSPOOL ON
/

SET TAB OFF
/

SET PAGESIZE 100
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_IAU_APPEND : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_IAU_APPEND
IDENTIFIED BY &SCHEMA_PASSWORD
DEFAULT TABLESPACE INFRADOMAIN_IAU
TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP'; 
end;

/

GRANT RESOURCE TO INFRADOMAIN_IAU_APPEND
/

GRANT UNLIMITED TABLESPACE to INFRADOMAIN_IAU_APPEND
/

GRANT CONNECT to INFRADOMAIN_IAU_APPEND
/

GRANT CREATE TABLE TO INFRADOMAIN_IAU_APPEND
/

GRANT CREATE MATERIALIZED VIEW TO INFRADOMAIN_IAU_APPEND
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''IAU_APPEND'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_IAU_APPEND
/

COMMIT
/

---------------------------------------------------------
---------- IAU_APPEND(Audit Services Append) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- IAU_VIEWER(Audit Services Viewer) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='IAU_VIEWER';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''IAU_VIEWER'', ''Audit Service Viewer'', ''INFRADOMAIN'', ''IAU_VIEWER'', ''IAU_VIEWER'', ''INFRADOMAIN_IAU_VIEWER'', ''12.2.1.2.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_IAU_VIEWER : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_IAU_VIEWER
IDENTIFIED BY &SCHEMA_PASSWORD
DEFAULT TABLESPACE INFRADOMAIN_IAU
TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP'; 
end;

/

GRANT RESOURCE TO INFRADOMAIN_IAU_VIEWER
/

GRANT UNLIMITED TABLESPACE to INFRADOMAIN_IAU_VIEWER
/

GRANT CONNECT to INFRADOMAIN_IAU_VIEWER
/

GRANT CREATE VIEW to INFRADOMAIN_IAU_VIEWER
/

GRANT CREATE SYNONYM TO INFRADOMAIN_IAU_VIEWER
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''IAU_VIEWER'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_IAU_VIEWER
/

COMMIT
/

---------------------------------------------------------
---------- IAU_VIEWER(Audit Services Viewer) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- MDS(Metadata Services) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='MDS';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''MDS'', ''Metadata Services'', ''INFRADOMAIN'', ''MDS'', ''MDS'', ''INFRADOMAIN_MDS'', ''12.2.1.3.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_MDS : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_MDS IDENTIFIED BY "&SCHEMA_PASSWORD" DEFAULT TABLESPACE INFRADOMAIN_MDS TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP'; 
end;

/

GRANT connect TO INFRADOMAIN_MDS
/

GRANT create type TO INFRADOMAIN_MDS
/

GRANT create procedure TO INFRADOMAIN_MDS
/

GRANT create table TO INFRADOMAIN_MDS
/

GRANT create sequence TO INFRADOMAIN_MDS
/

GRANT execute on dbms_lob to INFRADOMAIN_MDS
/

ALTER USER INFRADOMAIN_MDS QUOTA unlimited ON INFRADOMAIN_MDS
/

DECLARE
    cnt           NUMBER;

    package_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(package_not_found, -00942);

    insufficient_privs EXCEPTION;
    PRAGMA EXCEPTION_INIT(insufficient_privs, -01031);
BEGIN

    cnt := 0;
    SELECT count(*) INTO cnt FROM dba_tab_privs WHERE grantee = 'PUBLIC'
               AND owner='SYS' AND table_name='DBMS_OUTPUT'
               AND privilege='EXECUTE';
    IF (cnt = 0) THEN
        -- Grant MDS user execute on dbms_output only if PUBLIC
        -- doesn't have the privilege.
        EXECUTE IMMEDIATE 'GRANT execute ON dbms_output TO INFRADOMAIN_MDS';
    END IF;

    cnt := 0;
    SELECT count(*) INTO cnt FROM dba_tab_privs WHERE grantee = 'PUBLIC'
               AND owner='SYS' AND table_name='DBMS_STATS'
               AND privilege='EXECUTE';
    IF (cnt = 0) THEN
        -- Grant MDS user execute on dbms_stats only if PUBLIC
        -- doesn't have the privilege.
        EXECUTE IMMEDIATE 'GRANT execute ON dbms_stats TO INFRADOMAIN_MDS';
    END IF;

    EXCEPTION
       -- If the user doesn't have privilege to access dbms_* package,
       -- database will report that the package cannot be found. RCU
       -- even doesn't throw the exception to the user, since ORA-00942
       -- is an ignored error defined in its global configuration xml
      -- file. 
       WHEN package_not_found THEN
           RAISE insufficient_privs;
       WHEN OTHERS THEN
           RAISE;
END;

/


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''MDS'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_MDS
/

COMMIT
/

---------------------------------------------------------
---------- MDS(Metadata Services) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- UCSUMS(User Messaging Service) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='UCSUMS';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''UCSUMS'', ''User Messaging Service'', ''INFRADOMAIN'', ''UCSUMS'', ''UCSUMS'', ''INFRADOMAIN_UMS'', ''12.2.1.0.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

define schema_user = INFRADOMAIN_UMS

define schema_password = &SCHEMA_PASSWORD

define default_tablespace = INFRADOMAIN_IAS_UMS

define temp_tablespace = INFRADOMAIN_IAS_TEMP

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_UMS : " hide;
begin
 execute immediate 'create user INFRADOMAIN_UMS identified by &SCHEMA_PASSWORD'; 
end;

/

alter user INFRADOMAIN_UMS default tablespace INFRADOMAIN_IAS_UMS
/

alter user INFRADOMAIN_UMS temporary tablespace INFRADOMAIN_IAS_TEMP
/

alter user INFRADOMAIN_UMS quota unlimited on INFRADOMAIN_IAS_UMS
/

grant CREATE SESSION to INFRADOMAIN_UMS
/

grant CREATE TABLE to INFRADOMAIN_UMS
/

grant execute on sys.dbms_aq to INFRADOMAIN_UMS
/

grant execute on sys.dbms_aqadm to INFRADOMAIN_UMS
/

grant aq_administrator_role to INFRADOMAIN_UMS
/

grant aq_user_role to INFRADOMAIN_UMS
/

ALTER SESSION SET CURRENT_SCHEMA=INFRADOMAIN_UMS

/

CREATE TABLE ACCESS_POINT
(
    IDENTIFIER VARCHAR2(512) NOT NULL,
    AP_TYPE VARCHAR2(32),
    DELIVERY_TYPE VARCHAR2(32) NOT NULL,
    ADDRESS_VALUE VARCHAR2(512) NOT NULL,
    KEYWORD VARCHAR2(350),
    METADATA BLOB
)
/

ALTER TABLE ACCESS_POINT
    ADD CONSTRAINT ACCESS_POINT_PK PRIMARY KEY (IDENTIFIER)
/

CREATE TABLE ADDRESS
(
    ADDR_ID VARCHAR2(64) NOT NULL,
    DELIVERY_TYPE VARCHAR2(32),
    FAILOVER_ADDRESS_ID VARCHAR2(64),
    METADATA BLOB,
    ORIGINAL_RECIPIENT VARCHAR2(64),
    SUCCESS_STATUS VARCHAR2(128),
    TIMEOUT NUMBER,
    TYPE VARCHAR2(32),
    VALUE VARCHAR2(512),
    RECIPIENT_ID VARCHAR2(64),
    ADDRESS_STRING VARCHAR2(512),
    CREATION_DATE TIMESTAMP
)
/

ALTER TABLE ADDRESS
    ADD CONSTRAINT ADDRESS_PK PRIMARY KEY (ADDR_ID)
/

CREATE INDEX ADDRESS_FAILOVER_ADDRESS_IDX ON ADDRESS
    (FAILOVER_ADDRESS_ID )
/

CREATE TABLE CLIENT
(
    APPLICATION_NAME VARCHAR2(128) NOT NULL,
    TIME_STAMP TIMESTAMP,
    LOCK_VERSION NUMBER(12,0),
    AUTHORIZATION_ID VARCHAR2(128)
)
/

ALTER TABLE CLIENT
    ADD CONSTRAINT CLIENT_PK PRIMARY KEY (APPLICATION_NAME)
/

CREATE TABLE CLIENT_ACCESS_POINT
(
    ACCESS_POINT VARCHAR2(512) NOT NULL,
    APPLICATION_NAME VARCHAR2(128) NOT NULL,
    APPLICATION_INSTANCE_NAME VARCHAR2(128) NOT NULL,
    AUTHORIZATION_ID VARCHAR2(128)
)
/

ALTER TABLE CLIENT_ACCESS_POINT
    ADD CONSTRAINT CLIENT_ACCESS_POINT_PK PRIMARY KEY (ACCESS_POINT, APPLICATION_INSTANCE_NAME)
/

CREATE TABLE CLIENT_INSTANCE
(
    ID VARCHAR2(256) NOT NULL,
    CLIENT_ID VARCHAR2(128),
    INSTANCE_NAME VARCHAR2(256)
)
/

ALTER TABLE CLIENT_INSTANCE
    ADD CONSTRAINT CLIENT_INSTANCE_PK PRIMARY KEY (ID)
/

CREATE TABLE CLIENT_PARAMETER
(
    CLIENT_ID VARCHAR2(128) NOT NULL,
    PARAMETER_ID VARCHAR2(256) NOT NULL
)
/

ALTER TABLE CLIENT_PARAMETER ADD CONSTRAINT CLIENT_PARAMETER_PARAM_ID_UQ UNIQUE
    (PARAMETER_ID )
/

CREATE TABLE CLIENT_QUEUE
(
    APPLICATION_NAME VARCHAR2(128),
    QUEUE_ID VARCHAR2(128)
)
/

CREATE TABLE CLIENT_SESSION
(
    APPLICATION_NAME VARCHAR2(128) NOT NULL,
    INSTANCE_NAME VARCHAR2(256),
    ADDRESS VARCHAR2(512) NOT NULL,
    EXPIRATION TIMESTAMP
)
/

ALTER TABLE CLIENT_SESSION
    ADD CONSTRAINT CLIENT_SESSION_PK PRIMARY KEY (APPLICATION_NAME, ADDRESS)
/

CREATE TABLE DELIVERY_ATTEMPT
(
    ADDR_CHAIN_ID VARCHAR2(128),
    ADDRESS_ID VARCHAR2(128),
    CURRENT_STATUS_ID VARCHAR2(128),
    DELIVERY_ID VARCHAR2(1024) NOT NULL,
    DELIVERY_STATE VARCHAR2(32),
    FAILOVER_ORDER NUMBER,
    GMID VARCHAR2(512),
    HEAD_FLAG NUMBER(1),
    MID VARCHAR2(512),
    NEXT_DELIVERY VARCHAR2(512),
    ORIGINAL_RECIPIENT VARCHAR2(64),
    SENDER_ADDRESS VARCHAR2(128),
    TIME_STAMP TIMESTAMP,
    TOTAL_FAILOVERS NUMBER,
    CURRENT_RESEND NUMBER,
    MAX_RESEND NUMBER
)

/

ALTER TABLE DELIVERY_ATTEMPT
    ADD CONSTRAINT DELIVERY_ATTEMPT_PK PRIMARY KEY (DELIVERY_ID)
/

CREATE INDEX DELIVERY_ATTEMPT_MID_IDX ON DELIVERY_ATTEMPT
    (MID )
/

CREATE UNIQUE INDEX DELIVERY_ATTEMPT_GMID_UQ ON DELIVERY_ATTEMPT
    (GMID )
/

CREATE TABLE DELIVERY_CONTEXT
(
    MID VARCHAR2(512) NOT NULL,
    NS_INSTANCE VARCHAR2(128),
    APPLICATION VARCHAR2(128),
    APPLICATION_INSTANCE VARCHAR2(256),
    DRIVER VARCHAR2(512),
    OPERATION VARCHAR2(64),
    TIME_STAMP TIMESTAMP
)
/

ALTER TABLE DELIVERY_CONTEXT
    ADD CONSTRAINT DELIVERY_CONTEXT_PK PRIMARY KEY (MID)
/

CREATE TABLE DRIVER
(
    CAPABILITY VARCHAR2(64),
    DRIVER_NAME VARCHAR2(512) NOT NULL,
    LOCK_VERSION NUMBER(12,0),
    SPEED NUMBER,
    COST NUMBER,
    SUPPORTS_CANCEL NUMBER(1),
    SUPPORTS_REPLACE NUMBER(1),
    SUPPORTS_STATUS_POLLING NUMBER(1),
    SUPPORTS_TRACKING NUMBER(1),
    CHECKSUM NUMBER,
    DEFAULT_SENDER VARCHAR2(128),
    MIME_TYPES VARCHAR2(512),
    ENCODINGS VARCHAR2(512),
    PROTOCOLS VARCHAR2(512),
    CARRIERS VARCHAR2(512),
    DELIVERY_TYPES VARCHAR2(512),
    STATUS_TYPES VARCHAR2(1024),
    SENDER_ADDRESSES VARCHAR2(1024)
)
/

ALTER TABLE DRIVER
    ADD CONSTRAINT DRIVER_PK PRIMARY KEY (DRIVER_NAME)
/

CREATE TABLE DRIVER_QUEUE
(
    DRIVER_NAME VARCHAR2(512),
    QUEUE_ID VARCHAR2(128)
)
/

CREATE TABLE DRIVER_SESSION
(
    DRIVER_NAME VARCHAR2(512),
    ADDRESS VARCHAR2(512) NOT NULL,
    EXPIRATION TIMESTAMP
)
/

ALTER TABLE DRIVER_SESSION
    ADD CONSTRAINT DRIVER_SESSION_PK PRIMARY KEY (ADDRESS)
/

CREATE TABLE FILTER
(
    PATTERN VARCHAR2(1024),
    FIELD_TYPE VARCHAR2(64),
    FIELD_NAME VARCHAR2(128),
    ACTION VARCHAR2(64),
    APPLICATION_NAME VARCHAR2(128) NOT NULL,
    ORDINAL NUMBER NOT NULL
)
/

ALTER TABLE FILTER
    ADD CONSTRAINT FILTER_PK PRIMARY KEY (APPLICATION_NAME, ORDINAL)
/

CREATE TABLE MESSAGE
(
    INFO_ACCEPT_DATE TIMESTAMP,
    INFO_APPLICATION_NAME VARCHAR2(128),
    INFO_CARRIER_NAME VARCHAR2(128),
    INFO_CHUNK_SIZE NUMBER,
    INFO_CORRELATION_ID VARCHAR2(128),
    INFO_COST_LEVEL NUMBER,
    INFO_DELAY NUMBER,
    INFO_DELIVERY_TYPE VARCHAR2(64),
    INFO_DRIVER VARCHAR2(512),
    INFO_EXPIRATION NUMBER,
    INFO_FROM_ADDRESS VARCHAR2(512),
    INFO_GATEWAY_ID VARCHAR2(512),
    INFO_INSTANCE_NAME VARCHAR2(256),
    INFO_MAX_CHUNKS NUMBER,
    INFO_PRIORITY VARCHAR2(64),
    INFO_PROTOCOL VARCHAR2(64),
    INFO_RELIABILITY VARCHAR2(64),
    INFO_SESSION_TYPE VARCHAR2(64),
    INFO_SPEED_LEVEL NUMBER,
    INFO_STATUS_LEVEL VARCHAR2(64),
    INFO_TRACKING VARCHAR2(64),
    INFO_MAX_RESEND NUMBER,
    INFO_PROFILE_ID VARCHAR2(128),
    MESSAGE_ID VARCHAR2(512) NOT NULL,
    MESSAGE_OBJECT BLOB,
    VALID_FLAG VARCHAR2(20),
    MESSAGE_AUTH_ID VARCHAR2(128),
    CREATION_DATE TIMESTAMP
)
/

ALTER TABLE MESSAGE
    ADD CONSTRAINT MESSAGE_PK PRIMARY KEY (MESSAGE_ID)
/

CREATE TABLE MESSAGE_TRANSFORM
(
    TRANSFORM_KEY VARCHAR2(144) NOT NULL,
    TRANSFORM_MESSAGE_ID VARCHAR2(512) NOT NULL
)
/

ALTER TABLE MESSAGE_TRANSFORM
    ADD CONSTRAINT MESSAGE_TRANSFORM_PK PRIMARY KEY (TRANSFORM_KEY)
/

ALTER TABLE MESSAGE_TRANSFORM ADD CONSTRAINT MESSAGE_TRANSFORM_MSG_ID_UQ UNIQUE
    (TRANSFORM_MESSAGE_ID )
/

CREATE TABLE PARAMETER
(
    ID VARCHAR2(256) NOT NULL,
    PARAM_NAME VARCHAR2(128) NOT NULL,
    PARAM_VALUE VARCHAR2(256)
)
/

ALTER TABLE PARAMETER
    ADD CONSTRAINT PARAMETER_PK PRIMARY KEY (ID)
/

CREATE TABLE QUEUE
(
    QCF_JNDI_NAME VARCHAR2(256),
    QCF_OBJECT BLOB,
    QUEUE_JNDI_NAME VARCHAR2(256),
    QUEUE_OBJECT BLOB,
    QUEUE_ID VARCHAR2(128) NOT NULL
)
/

ALTER TABLE QUEUE
    ADD CONSTRAINT QUEUE_PK PRIMARY KEY (QUEUE_ID)
/

CREATE TABLE STATUS
(
    ADDRESS_ID VARCHAR2(128),
    CONTENT VARCHAR2(1024),
    DRIVER VARCHAR2(512),
    FAILOVER_ORDER NUMBER,
    FAILOVER_STATUS_ID VARCHAR2(128),
    GATEWAY_ID VARCHAR2(512),
    MESSAGE_ID VARCHAR2(512),
    METADATA BLOB,
    RECIPIENT_ID VARCHAR2(128),
    STATUS_DATE TIMESTAMP,
    STATUS_ID VARCHAR2(128) NOT NULL,
    TOTAL_FAILOVERS NUMBER,
    MAX_RESEND NUMBER,
    CURRENT_RESEND NUMBER,
    TYPE VARCHAR2(128)
)
/

ALTER TABLE STATUS
    ADD CONSTRAINT STATUS_PK PRIMARY KEY (STATUS_ID)
/

CREATE TABLE STATUS_ORPHAN
(
    GMID VARCHAR2(512) NOT NULL,
    STATUS_ID VARCHAR2(128) NOT NULL
)
/

CREATE INDEX STATUS_ORPHAN_GMID_IDX ON STATUS_ORPHAN
    (GMID )
/

CREATE TABLE DEVICE_ADDRESS
(
    ID VARCHAR2(128) NOT NULL,
    USER_GUID VARCHAR2(128) NOT NULL,
    NAME VARCHAR2(128) NOT NULL,
    ADDRESS VARCHAR2(512) NOT NULL,
    DEFAULT_ADDRESS VARCHAR2(1) DEFAULT 'N',
    CARRIER VARCHAR2(256),
    ENCODING VARCHAR2(64),
    DELIVERY_INFO VARCHAR2(64),
    DELIVERY_MODE VARCHAR2(64) NOT NULL,
    DESCRIPTION VARCHAR2(2000),
    CREATED TIMESTAMP,
    LAST_MODIFIED TIMESTAMP,
    VERSION NUMBER(10,0),
    VALID VARCHAR2(1) DEFAULT 'N',
    UDEV_ID VARCHAR2(128),
    TYPE VARCHAR2(10) DEFAULT 'UCP',
    REFERENCE_KEY VARCHAR2(256),
    METADATA BLOB,
    EXT_DATE TIMESTAMP,
    EXT_CHAR1 VARCHAR2(2000),
    EXT_CHAR2 VARCHAR2(2000),
    EXT_CHAR3 VARCHAR2(2000)
)
/

ALTER TABLE DEVICE_ADDRESS
    ADD CONSTRAINT DEVICE_ADDRESS_PK PRIMARY KEY (ID)
/

ALTER TABLE DEVICE_ADDRESS ADD CONSTRAINT DEVICE_ADDRESS_ADDRS_DELIV_UQ UNIQUE
    (ADDRESS , DELIVERY_MODE )
/

ALTER TABLE DEVICE_ADDRESS ADD CONSTRAINT DEVICE_ADDRESS_USER_NAME_UQ UNIQUE
    (USER_GUID , NAME )
/

CREATE INDEX DEVICE_ADDRESS_UDEV_ID_IDX ON DEVICE_ADDRESS
    (UDEV_ID )
/

ALTER TABLE DEVICE_ADDRESS
    ADD CONSTRAINT DEVICE_ADDRESS_VALID_CK CHECK (VALID IN ('Y', 'N'))
/

ALTER TABLE DEVICE_ADDRESS
    ADD CONSTRAINT DEVICE_ADDRESS_DEFAULT_ADDR_CK CHECK (DEFAULT_ADDRESS IN ('Y', 'N'))
/

ALTER TABLE DEVICE_ADDRESS
    ADD CONSTRAINT DEVICE_ADDRESS_TYPE_CK CHECK (TYPE IN ('UCP', 'IDM'))
/

CREATE TABLE RULE_SET
(
    USER_GUID VARCHAR2(128) NOT NULL,
    PROFILE_ID VARCHAR2(128) DEFAULT 'defaultId' NOT NULL,
    MEDIA_TYPE_ID NUMBER(3) DEFAULT 1 NOT NULL,
    FILTER_XML CLOB,
    FILTER_XML_UCP CLOB,
    RL CLOB,
    RULE_SESSION BLOB,
    DESCRIPTION VARCHAR2(2000),
    CREATED TIMESTAMP,
    LAST_MODIFIED TIMESTAMP,
    VERSION NUMBER(10,0),
    VALID VARCHAR2(1) DEFAULT 'N',
    EXT_DATE TIMESTAMP,
    EXT_CHAR1 VARCHAR2(2000),
    EXT_CHAR2 VARCHAR2(2000),
    EXT_CHAR3 VARCHAR2(2000)
)
/

ALTER TABLE RULE_SET
    ADD CONSTRAINT RULE_SET_PK PRIMARY KEY (USER_GUID, PROFILE_ID, MEDIA_TYPE_ID)
/

ALTER TABLE RULE_SET
    ADD CONSTRAINT RULE_SET_VALID_CK CHECK (VALID IN ('Y', 'N'))
/

CREATE TABLE UCP_MEDIA_TYPE
(
    ID NUMBER(3) NOT NULL,
    NAME VARCHAR2(32) NOT NULL
)
/

ALTER TABLE UCP_MEDIA_TYPE
    ADD CONSTRAINT UCP_MEDIA_TYPE_PK PRIMARY KEY (ID)
/

CREATE TABLE UCP_USER_ATTRIBUTE
(
    USER_GUID VARCHAR2(128) NOT NULL,
    NAME VARCHAR2(256) NOT NULL,
    VALUE VARCHAR2(2000),
    CREATED TIMESTAMP,
    LAST_MODIFIED TIMESTAMP,
    VERSION NUMBER(10,0)
)
/

ALTER TABLE UCP_USER_ATTRIBUTE
    ADD CONSTRAINT UCP_USER_ATTRIBUTE_PK PRIMARY KEY (USER_GUID, NAME)
/

CREATE TABLE USER_DEVICE
(
    ID VARCHAR2(128) NOT NULL,
    USER_GUID VARCHAR2(128) NOT NULL,
    NAME VARCHAR2(128) NOT NULL,
    DESCRIPTION VARCHAR2(2000),
    CREATED TIMESTAMP,
    LAST_MODIFIED TIMESTAMP,
    VERSION NUMBER(10,0),
    VALID VARCHAR2(1) DEFAULT 'N'
)
/

ALTER TABLE USER_DEVICE
    ADD CONSTRAINT USER_DEVICE_PK PRIMARY KEY (ID)
/

ALTER TABLE USER_DEVICE ADD CONSTRAINT USER_DEVICE_USER_GUID_NAME_UQ UNIQUE
    (USER_GUID , NAME )
/

ALTER TABLE USER_DEVICE
    ADD CONSTRAINT USER_DEVICE_VALID_CK CHECK (VALID IN ('Y', 'N'))
/

ALTER TABLE ADDRESS
    ADD CONSTRAINT ADDRESS_FAILOVER_ADDRESS FOREIGN KEY (FAILOVER_ADDRESS_ID) REFERENCES ADDRESS (ADDR_ID)
/

ALTER TABLE RULE_SET
    ADD CONSTRAINT RULE_SET_FK2 FOREIGN KEY (MEDIA_TYPE_ID) REFERENCES UCP_MEDIA_TYPE (ID)
/

INSERT INTO UCP_MEDIA_TYPE (ID, NAME) VALUES(1,'MESSAGING')

/

INSERT INTO UCP_MEDIA_TYPE (ID, NAME) VALUES(2,'VOICE_CALL')

/

DEFINE schema_user = INFRADOMAIN_UMS

ALTER SESSION SET CURRENT_SCHEMA=INFRADOMAIN_UMS
/

BEGIN
DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMAppDefRcvT1',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMAppDefRcvQ1', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMAppDefRcvT1' , max_retries => 2);

DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineCmdT',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineCmdQ', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineCmdT', max_retries => 2);

DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineSndT1',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineSndQ1', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineSndT1', max_retries => 2);

DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineRcvT1',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineRcvQ1', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEngineRcvT1', max_retries => 2);


DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMWSRcvT1',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMWSRcvQ1', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMWSRcvT1', max_retries => 2);

DBMS_AQADM.CREATE_QUEUE_TABLE(
	queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMDriverDefSndT1',
	queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
	sort_list => 'PRIORITY,ENQ_TIME',
	multiple_consumers => false,
	compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMDriverDefSndQ1', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMDriverDefSndT1', max_retries => 2);

DBMS_AQADM.CREATE_QUEUE_TABLE(
    queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEnginePendRcvQT',
    queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
    sort_list => 'PRIORITY,ENQ_TIME',
    multiple_consumers => false,
    compatible => '10.0');
DBMS_AQADM.CREATE_QUEUE( queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEnginePendingRcvQ', queue_table => 'INFRADOMAIN_UMS' || '.OraSDPMEnginePendRcvQT', max_retries => 2);

DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMAppDefRcvQ1');
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.AQ$_OraSDPMAppDefRcvT1_E', dequeue => TRUE, enqueue => FALSE);
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineCmdQ');
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineSndQ1');
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEngineRcvQ1');
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMEnginePendingRcvQ');
DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMWSRcvQ1');

DBMS_AQADM.START_QUEUE(queue_name => 'INFRADOMAIN_UMS' || '.OraSDPMDriverDefSndQ1');
END;

/

DEFINE schema_user = INFRADOMAIN_UMS

ALTER SESSION SET CURRENT_SCHEMA=INFRADOMAIN_UMS
/

CREATE OR REPLACE PACKAGE UMS_CLEANUP AS

	-- Main purge procedure
	PROCEDURE PURGE (days_of_retention IN NUMBER);

	-- procedure to update MESSGAGE, DELIVERY_CONTEXT, and ADDRESS tables
	procedure update_message_date(cut_off_time IN date);

	-- Procedure to purge MESSAGE table
	procedure purge_message(cut_off_time IN date);

	-- procedures to update ADRESS table failoverchains
	procedure update_failover_address(cut_off_time IN date);
	
	procedure update_failover_address2(cut_off_time IN date);
	
	-- procedure to decouple adresses from failover addresses in ADDRESS table
	procedure decouple_failover_address(cut_off_time IN date);
	
	-- procedure to purge ADDRESS table
	procedure purge_address(cut_off_time IN date);
	
	-- procedure to purge STATUS table
	procedure purge_status(cut_off_time IN date);
	
	-- procedure to purge DELIVERY_CONTEXT table
	procedure purge_delivery_context(cut_off_time IN date);
	
	-- procedure to purge DELIVERY_ATTEMPT table
	procedure purge_delivery_attempt(cut_off_time IN date);


END UMS_CLEANUP;

/

show errors;
/

CREATE OR REPLACE PACKAGE BODY UMS_CLEANUP AS

	-- Main purge procedure
	PROCEDURE PURGE (days_of_retention IN NUMBER) AS

		cut_off_date DATE;
		nrows	NUMBER;

		BEGIN

		DBMS_OUTPUT.put_line(CHR(10));

		if(days_of_retention < 7) then
			DBMS_OUTPUT.put_line('ERROR:  Parameter "days_of_retention" is too short. The minimum value allowed is 7 days.');
			goto endp;		
		end if;

		DBMS_OUTPUT.put_line('------ Before Purge ---------');
		DBMS_OUTPUT.put_line(CHR(10));

		select count(1) into nrows from MESSAGE;
		DBMS_OUTPUT.put_line('MESSAGE table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from ADDRESS;
		DBMS_OUTPUT.put_line('ADDRESS table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from DELIVERY_ATTEMPT;
		DBMS_OUTPUT.put_line('DELIVERY_ATTEMPT table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from STATUS;
		DBMS_OUTPUT.put_line('STATUS table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from DELIVERY_CONTEXT;
		DBMS_OUTPUT.put_line('DELIVERY_CONTEXT table:'|| CHR(9) || nrows || ' rows');

		cut_off_date := sysdate - days_of_retention;

		DBMS_OUTPUT.put_line(CHR(10));

		DBMS_OUTPUT.put_line('Cut-off date/time is:  ' || to_char(cut_off_date, 'YYYY-MM-DD HH24:MI:SS'));
		DBMS_OUTPUT.put_line('All records created prior to that point will be DELETED permanently.');

		-- -------------------- Update MESSAGE table ---------------------
		DBMS_OUTPUT.put_line('**** Update MESSAGE, CONTEXT, ADDRESS table for different times. Please wait ...');
		update_message_date(cut_off_date);

		-- -------------------- Purge MESSAGE table ---------------------
		DBMS_OUTPUT.put_line('**** Purging MESSAGE table. Please wait ...');
		purge_message(cut_off_date);

		-- -------------------- Purge ADDRESS table ---------------------
		DBMS_OUTPUT.put_line('**** Purging ADDRESS table. Please wait ...');

		update DELIVERY_ATTEMPT set time_stamp = cut_off_date - 1
		where MID in (select unique MID from DELIVERY_CONTEXT where TIME_STAMP < cut_off_date)
		  and time_stamp is null;

		-- -------------------- Delete addresses ---------------------	
		update_failover_address(cut_off_date);
		update_failover_address2(cut_off_date);
		decouple_failover_address(cut_off_date);
		purge_address(cut_off_date);

		-- -------------------- Purge DELIVERY_ATTEMPT table ---------------------
		DBMS_OUTPUT.put_line('**** Purging DELIVERY_ATTEMPT table. Please wait ...');
		purge_delivery_attempt(cut_off_date);

		-- -------------------- Purge STATUS table ---------------------
		DBMS_OUTPUT.put_line('**** Purging STATUS table. Please wait ...');
		purge_status(cut_off_date);

		-- -------------------- Purge DELIVERY_CONTEXT table ---------------------
		DBMS_OUTPUT.put_line('**** Purging DELIVERY_CONTEXT table. Please wait ...');
		purge_delivery_context(cut_off_date);

		DBMS_OUTPUT.put_line('**** Purge completed.');
		DBMS_OUTPUT.put_line(CHR(10));
		DBMS_OUTPUT.put_line('------ After Purge ---------');
		DBMS_OUTPUT.put_line(CHR(10));

		nrows := 0;
		select count(1) into nrows from MESSAGE;
		DBMS_OUTPUT.put_line('MESSAGE table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from ADDRESS;
		DBMS_OUTPUT.put_line('ADDRESS table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from DELIVERY_ATTEMPT;
		DBMS_OUTPUT.put_line('DELIVERY_ATTEMPT table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from STATUS;
		DBMS_OUTPUT.put_line('STATUS table:'|| CHR(9) || nrows || ' rows');

		nrows := 0;
		select count(1) into nrows from DELIVERY_CONTEXT;
		DBMS_OUTPUT.put_line('DELIVERY_CONTEXT table:'|| CHR(9) || nrows || ' rows');

	<<endp>>	
		DBMS_OUTPUT.put_line(CHR(10));

		END PURGE;

        -- Procedure to change date/timestamp to ATTEMPT timestamp for inconsistent dates
        procedure update_message_date(cut_off_time IN date) IS
                CURSOR C1 is
                    select da.mid, da.TIME_STAMP, da.sender_address, da.address_id from 
                        DELIVERY_ATTEMPT da, DELIVERY_CONTEXT dc where
                        da.mid = dc.mid and da.TIME_STAMP >= cut_off_time and dc.TIME_STAMP < cut_off_time;

                CURSOR C2 IS
                    Select da.mid, da.TIME_STAMP, da.sender_address, da.address_id from 
                        DELIVERY_ATTEMPT da, MESSAGE msg where
			msg.CREATION_DATE is null;

                msg_id  VARCHAR2(128);
                msg_time TIMESTAMP(6);
                sender_addr VARCHAR2(128);
                recip_addr VARCHAR2(128);
                lv_commit_size NUMBER := 100;
                lv_count NUMBER := 0;

        BEGIN

                FOR record IN C1 LOOP
                    msg_id := record.mid;
                    msg_time := record.TIME_STAMP;
                    sender_addr := record.sender_address;
                    recip_addr := record.address_id;

                    update DELIVERY_CONTEXT set TIME_STAMP = msg_time where
                        mid = msg_id;

                    update MESSAGE set CREATION_DATE = msg_time where 
                        message_id = msg_id;

                    update ADDRESS set CREATION_DATE = msg_time where
                        addr_id = sender_addr;

                    update ADDRESS set CREATION_DATE = msg_time where
                        addr_id = recip_addr;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;

		FOR record IN C2 LOOP

                    msg_id := record.mid;
                    msg_time := record.TIME_STAMP;
                    sender_addr := record.sender_address;
                    recip_addr := record.address_id;


                    update MESSAGE set CREATION_DATE = msg_time where 
                        message_id = msg_id;

                    update ADDRESS set CREATION_DATE = msg_time where
                        addr_id = sender_addr;

                    update ADDRESS set CREATION_DATE = msg_time where
                        addr_id = recip_addr;
		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;	
	
		DBMS_OUTPUT.put_line(lv_count);

	END update_message_date;

 
	-- Procedure to purge MESSAGE table
	procedure purge_message(cut_off_time IN date) IS
		CURSOR C1 is
		    Select m.message_id from MESSAGE m, DELIVERY_CONTEXT dc where
			m.message_id = dc.mid and dc.TIME_STAMP < cut_off_time;

		msg_id	VARCHAR2(128);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		

	BEGIN

		FOR record IN C1 LOOP
		    msg_id := record.message_id;

		    delete from MESSAGE where message_id = msg_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		
		DBMS_OUTPUT.put_line(lv_count);

	END purge_message;
	

	-- Procedure to change date/timestamp to preserve failoverchains
  	procedure update_failover_address(cut_off_time IN date) IS
  
		CURSOR C1 IS
			select unique addr_id from ADDRESS where failover_address_id in (select unique addr_id from ADDRESS where creation_date > cut_off_time) and creation_date < cut_off_time;

		a_id	VARCHAR2(64);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		DBMS_OUTPUT.put_line('Update addresses...');

		FOR record IN C1 LOOP
		    a_id := record.addr_id;
		    update ADDRESS set CREATION_DATE = cut_off_time + 1 where addr_id = a_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		
		DBMS_OUTPUT.put_line(lv_count);

	END update_failover_address;

  procedure update_failover_address2(cut_off_time IN date) IS
  
		CURSOR C1 IS
        	select unique addr_id from ADDRESS where failover_address_id is null and addr_id in (select unique failover_address_id from ADDRESS where creation_date > cut_off_time) and creation_date < cut_off_time;

		a_id	VARCHAR2(64);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		DBMS_OUTPUT.put_line('Update addresses 2...');

		FOR record IN C1 LOOP
		    a_id := record.addr_id;
		    update ADDRESS set CREATION_DATE = cut_off_time + 1 where addr_id = a_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
          		commit;

          		DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		
		DBMS_OUTPUT.put_line(lv_count);


	END update_failover_address2;

	-- procedure to decouple adresses from failover addresses in ADDRESS table
	procedure decouple_failover_address(cut_off_time IN date) IS

		CURSOR C1 IS
			select addr_id from address where
                            failover_address_id is not null and CREATION_DATE < cut_off_time;

		a_id	VARCHAR2(64);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		DBMS_OUTPUT.put_line('Decouple adresses from failover addresses...');

		FOR record IN C1 LOOP
		    a_id := record.addr_id;
        update ADDRESS set failover_address_id = null where addr_id = a_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		
		DBMS_OUTPUT.put_line(lv_count);

	END decouple_failover_address;
	
	-- procedure to purge senders from ADDRESS table
	procedure purge_address(cut_off_time IN date) IS

		CURSOR C1 IS
			Select addr_id from address where
                            CREATION_DATE < cut_off_time;

		a_id	VARCHAR2(64);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		DBMS_OUTPUT.put_line('Deleting addresses from ADDRESS table...');

		FOR record IN C1 LOOP
		    a_id := record.addr_id;

		    delete from ADDRESS where addr_id = a_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		
		DBMS_OUTPUT.put_line(lv_count);

	END purge_address;
	

	-- procedure to purge STATUS table
	procedure purge_status(cut_off_time IN date) IS

		CURSOR C1 IS
			Select STATUS_ID from status 
			where STATUS_DATE < cut_off_time;


		s_id	VARCHAR2(128);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		FOR record IN C1 LOOP
		    s_id := record.status_id;

		    delete from status where status_id = s_id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		

		DBMS_OUTPUT.put_line(lv_count);

	END purge_status;
	
	-- procedure to purge DELIVERY_CONTEXT table
	procedure purge_delivery_context(cut_off_time IN date) IS

		CURSOR C1 IS
			Select MID from DELIVERY_CONTEXT 
			where TIME_STAMP < cut_off_time;


		id	VARCHAR2(128);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		FOR record IN C1 LOOP
		    id := record.mid;

		    delete from DELIVERY_CONTEXT where mid = id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		

		DBMS_OUTPUT.put_line(lv_count);

	END purge_delivery_context;
	

	-- procedure to purge DELIVERY_ATTEMPT table
	procedure purge_delivery_attempt(cut_off_time IN date) IS

		CURSOR C1 IS
			Select DELIVERY_ID from DELIVERY_ATTEMPT 
			where TIME_STAMP < cut_off_time;


		id	VARCHAR2(256);
		lv_commit_size NUMBER := 100;
		lv_count NUMBER := 0;		
	BEGIN

		FOR record IN C1 LOOP
		    id := record.DELIVERY_ID;

		    delete from DELIVERY_ATTEMPT where DELIVERY_ID = id;

		    lv_count := lv_count + 1;
		    if mod(lv_count, lv_commit_size) = 0 then
			commit;

			DBMS_OUTPUT.put_line(lv_count);

		    end if;            

		END LOOP;
		commit;		

		DBMS_OUTPUT.put_line(lv_count);

	END purge_delivery_attempt;
	

END UMS_CLEANUP;


/

show errors;
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''UCSUMS'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_UMS
/

COMMIT
/

---------------------------------------------------------
---------- UCSUMS(User Messaging Service) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- IAU(Audit Services) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='IAU';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''IAU'', ''Audit Service'', ''INFRADOMAIN'', ''IAU'', ''IAU'', ''INFRADOMAIN_IAU'', ''12.2.1.2.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_IAU : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_IAU 
    IDENTIFIED BY &SCHEMA_PASSWORD 
    DEFAULT TABLESPACE INFRADOMAIN_IAU 
    TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP'; 
end;

/

GRANT RESOURCE TO INFRADOMAIN_IAU
/

GRANT UNLIMITED TABLESPACE to INFRADOMAIN_IAU
/

GRANT CONNECT TO INFRADOMAIN_IAU
/

GRANT CREATE TYPE TO INFRADOMAIN_IAU
/

GRANT CREATE PROCEDURE TO INFRADOMAIN_IAU
/

GRANT CREATE TABLE TO INFRADOMAIN_IAU
/

GRANT CREATE SEQUENCE TO INFRADOMAIN_IAU
/

GRANT CREATE SESSION TO INFRADOMAIN_IAU
/

GRANT CREATE INDEXTYPE TO INFRADOMAIN_IAU
/

GRANT CREATE SYNONYM TO INFRADOMAIN_IAU
/

GRANT SELECT_CATALOG_ROLE to INFRADOMAIN_IAU
/

GRANT SELECT ON SCHEMA_VERSION_REGISTRY TO INFRADOMAIN_IAU
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_BASE FOR INFRADOMAIN_IAU.IAU_BASE
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_BASE FOR INFRADOMAIN_IAU.IAU_BASE
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.AdminServer FOR INFRADOMAIN_IAU.AdminServer
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.AdminServer FOR INFRADOMAIN_IAU.AdminServer
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.DIP FOR INFRADOMAIN_IAU.DIP
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.DIP FOR INFRADOMAIN_IAU.DIP
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.JPS FOR INFRADOMAIN_IAU.JPS
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.JPS FOR INFRADOMAIN_IAU.JPS
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OAAM FOR INFRADOMAIN_IAU.OAAM
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OAAM FOR INFRADOMAIN_IAU.OAAM
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OAM FOR INFRADOMAIN_IAU.OAM
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OAM FOR INFRADOMAIN_IAU.OAM
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OHSComponent FOR INFRADOMAIN_IAU.OHSComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OHSComponent FOR INFRADOMAIN_IAU.OHSComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OIDComponent FOR INFRADOMAIN_IAU.OIDComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OIDComponent FOR INFRADOMAIN_IAU.OIDComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OIF FOR INFRADOMAIN_IAU.OIF
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OIF FOR INFRADOMAIN_IAU.OIF
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OVDComponent FOR INFRADOMAIN_IAU.OVDComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OVDComponent FOR INFRADOMAIN_IAU.OVDComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OWSM_AGENT FOR INFRADOMAIN_IAU.OWSM_AGENT
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OWSM_AGENT FOR INFRADOMAIN_IAU.OWSM_AGENT
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.OWSM_PM_EJB FOR INFRADOMAIN_IAU.OWSM_PM_EJB
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.OWSM_PM_EJB FOR INFRADOMAIN_IAU.OWSM_PM_EJB
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.ReportsServerComponent FOR INFRADOMAIN_IAU.ReportsServerComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.ReportsServerComponent FOR INFRADOMAIN_IAU.ReportsServerComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.SOA_B2B FOR INFRADOMAIN_IAU.SOA_B2B
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.SOA_B2B FOR INFRADOMAIN_IAU.SOA_B2B
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.SOA_HCFP FOR INFRADOMAIN_IAU.SOA_HCFP
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.SOA_HCFP FOR INFRADOMAIN_IAU.SOA_HCFP
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.STS FOR INFRADOMAIN_IAU.STS
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.STS FOR INFRADOMAIN_IAU.STS
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.WS_PolicyAttachment FOR INFRADOMAIN_IAU.WS_PolicyAttachment
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.WS_PolicyAttachment FOR INFRADOMAIN_IAU.WS_PolicyAttachment
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.WebCacheComponent FOR INFRADOMAIN_IAU.WebCacheComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.WebCacheComponent FOR INFRADOMAIN_IAU.WebCacheComponent
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.WebServices FOR INFRADOMAIN_IAU.WebServices
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.WebServices FOR INFRADOMAIN_IAU.WebServices
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.xmlpserver FOR INFRADOMAIN_IAU.xmlpserver
/

CREATE OR REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.xmlpserver FOR INFRADOMAIN_IAU.xmlpserver
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_COMMON FOR INFRADOMAIN_IAU.IAU_COMMON
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_COMMON FOR INFRADOMAIN_IAU.IAU_COMMON
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_CUSTOM FOR INFRADOMAIN_IAU.IAU_CUSTOM
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_CUSTOM FOR INFRADOMAIN_IAU.IAU_CUSTOM
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_CUSTOM_01 FOR INFRADOMAIN_IAU.IAU_CUSTOM_01
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_CUSTOM_01 FOR INFRADOMAIN_IAU.IAU_CUSTOM_01
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_SCHEMA_VERSION FOR INFRADOMAIN_IAU.IAU_SCHEMA_VERSION
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_SCHEMA_VERSION FOR INFRADOMAIN_IAU.IAU_SCHEMA_VERSION
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_USERSESSION FOR INFRADOMAIN_IAU.IAU_USERSESSION
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_USERSESSION FOR INFRADOMAIN_IAU.IAU_USERSESSION
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_AUDITSERVICE FOR INFRADOMAIN_IAU.IAU_AUDITSERVICE
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.IAU_AUDITSERVICE FOR INFRADOMAIN_IAU.IAU_AUDITSERVICE
/

create or replace synonym INFRADOMAIN_IAU_VIEWER.list_of_components for INFRADOMAIN_IAU.list_of_components
/

create or replace synonym INFRADOMAIN_IAU_APPEND.list_of_components for INFRADOMAIN_IAU.list_of_components
/

create or replace synonym INFRADOMAIN_IAU_VIEWER.attribute_value_pairs for INFRADOMAIN_IAU.attribute_value_pairs
/

create or replace synonym INFRADOMAIN_IAU_APPEND.attribute_value_pairs for INFRADOMAIN_IAU.attribute_value_pairs
/

create or replace synonym INFRADOMAIN_IAU_VIEWER.auditreports_pkg for INFRADOMAIN_IAU.auditreports_pkg
/

create or replace synonym INFRADOMAIN_IAU_APPEND.auditreports_pkg for INFRADOMAIN_IAU.auditreports_pkg
/

create or replace synonym INFRADOMAIN_IAU_VIEWER.list_of_events for INFRADOMAIN_IAU.list_of_events
/

create or replace synonym INFRADOMAIN_IAU_APPEND.list_of_events for INFRADOMAIN_IAU.list_of_events
/

create or replace synonym INFRADOMAIN_IAU_VIEWER.auditschema_pkg for INFRADOMAIN_IAU.auditschema_pkg
/

create or replace synonym INFRADOMAIN_IAU_APPEND.auditschema_pkg for INFRADOMAIN_IAU.auditschema_pkg
/

CREATE or replace SYNONYM INFRADOMAIN_IAU_APPEND.ID_SEQ FOR INFRADOMAIN_IAU.ID_SEQ
/

CREATE or REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_DISP_NAMES_TL FOR INFRADOMAIN_IAU.IAU_DISP_NAMES_TL
/

CREATE or REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.IAU_DISP_NAMES_TL FOR INFRADOMAIN_IAU.IAU_DISP_NAMES_TL
/

CREATE or REPLACE SYNONYM INFRADOMAIN_IAU_VIEWER.IAU_LOCALE_MAP_TL FOR INFRADOMAIN_IAU.IAU_LOCALE_MAP_TL
/

CREATE or REPLACE SYNONYM INFRADOMAIN_IAU_APPEND.IAU_LOCALE_MAP_TL FOR INFRADOMAIN_IAU.IAU_LOCALE_MAP_TL
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''IAU'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_IAU
/

COMMIT
/

---------------------------------------------------------
---------- IAU(Audit Services) SECTION ENDS ----------
---------------------------------------------------------


---------------------------------------------------------
---------- OPSS(Oracle Platform Security Services) SECTION STARTS ----------
---------------------------------------------------------


DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'ALTER TABLE '||loc||'.SCHEMA_VERSION_REGISTRY$ ADD EDITION VARCHAR2(30)';
EXCEPTION WHEN OTHERS THEN NULL;
END;

/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  DECLARE
    compCnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO compCnt FROM SCHEMA_VERSION_REGISTRY
      WHERE MRC_NAME='INFRADOMAIN' and COMP_ID='OPSS';
    IF compCnt = 0 THEN
      EXECUTE IMMEDIATE 'INSERT INTO '||loc||'.SCHEMA_VERSION_REGISTRY$ (comp_id, comp_name, mrc_name, mr_name, mr_type, owner, version, status, edition, custom1) VALUES (''OPSS'', ''Oracle Platform Security Services'', ''INFRADOMAIN'', ''OPSS'', ''OPSS'', ''INFRADOMAIN_OPSS'', ''12.2.1.0.0'', ''LOADING'', '''', 0)';
    END IF;
  END;
END;

/

COMMIT
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE REGISTRYACCESS';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY$ TO REGISTRYACCESS';
  EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||loc||'.SCHEMA_VERSION_REGISTRY TO REGISTRYACCESS';
END;

/

COMMIT
/

accept SCHEMA_PASSWORD char prompt "Enter the schema password for user INFRADOMAIN_OPSS : " hide;
begin
 execute immediate 'CREATE USER INFRADOMAIN_OPSS 
    IDENTIFIED BY "&SCHEMA_PASSWORD" 
    DEFAULT TABLESPACE INFRADOMAIN_IAS_OPSS 
    TEMPORARY TABLESPACE INFRADOMAIN_IAS_TEMP '; 
end;

/

GRANT CREATE CLUSTER, 
    CREATE INDEXTYPE, 
    CREATE OPERATOR, 
    CREATE PROCEDURE,
    CREATE SEQUENCE,
    CREATE SESSION,
    CREATE TABLE,
    CREATE TRIGGER,
    CREATE TYPE,
    CREATE VIEW TO INFRADOMAIN_OPSS 
/

ALTER USER INFRADOMAIN_OPSS QUOTA UNLIMITED ON INFRADOMAIN_IAS_OPSS 
/

DECLARE
  loc VARCHAR2(128);
BEGIN
  SELECT owner into loc from all_tables where table_name = 'SCHEMA_VERSION_REGISTRY$' and owner in ('SYSTEM', 'FMWREGISTRY');
  EXECUTE IMMEDIATE 'UPDATE '||loc||'.SCHEMA_VERSION_REGISTRY$ SET status=''LOADED'' WHERE comp_id=''OPSS'' AND mrc_name=''INFRADOMAIN''';
END;

/

COMMIT
/

GRANT REGISTRYACCESS TO INFRADOMAIN_OPSS
/

COMMIT
/

---------------------------------------------------------
---------- OPSS(Oracle Platform Security Services) SECTION ENDS ----------
---------------------------------------------------------


EXIT;