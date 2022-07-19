###### SERVER JDK
FROM oraclelinux:8 as serverjdk
# HOST OS NGINX local repo trick
ARG REMOTE_REPO=http://172.17.0.1:8008

ENV JAVA_PKG=jdk-8u321-linux-x64.tar.gz \
    JAVA_HOME=/usr/java/default

USER root
# libnsl = OHS dependency
RUN yum install -y vim mc tar bzip2 hostname wget libnsl binutils gcc gcc-c++ glibc.x86_64 glibc.i686 glibc-devel.x86_64 libaio.x86_64 libaio-devel.x86_64 libgcc.x86_64 libgcc.i686 libstdc++.x86_64 libstdc++.i686 libstdc++-devel.x86_64 ksh make sysstat numactl numactl-devel motif motif-devel

RUN mkdir /usr/java && cd /usr/java \
    && wget --no-verbose --progress=bar "$REMOTE_REPO/$JAVA_PKG"  \
    && tar -xf /usr/java/$JAVA_PKG && rm -f /usr/java/*.tar.gz

RUN export JAVA_DIR=/usr/java/jdk1.8.0_321 && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000

###### FMW INFRA
FROM serverjdk AS fmw-infra
# HOST OS NGINX local repo trick
ARG REMOTE_REPO=http://172.17.0.1:8008

# Common environment variables required for this build
# ----------------------------------------------------
ENV ORACLE_HOME=/u01/oracle \
    SCRIPT_FILES=/opt/container-scripts/*.sh \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    DOMAIN_NAME="${DOMAIN_NAME:-InfraDomain}" \
    DOMAIN_HOME=/u01/oracle/user_projects/domains/${DOMAIN_NAME:-InfraDomain} \
    VOLUME_DIR=/u01/oracle/user_projects \
    PATH=$PATH:/usr/java/default/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/opt/container-scripts

# Setup subdirectory for FMW install package and container-scripts
# -----------------------------------------------------------------
RUN mkdir -p /u01 && \
    chmod a+xr /u01 && \
    useradd -b /u01 -d /u01/oracle -m -s /bin/bash oracle && \
    mkdir -p /u01/oracle/oraInventory /u01/oracle/user_projects && \
    chown -R oracle.root /opt /u01

USER oracle

ENV FMW_JAR=fmw_12.2.1.4.0_infrastructure.jar

COPY install.file oraInst.loc /u01/

RUN mkdir -p /opt/ora-reports-install \
   && cd /u01 \
   && wget --no-verbose --progress=bar "$REMOTE_REPO/$FMW_JAR" \
   && chmod +x $FMW_JAR \
   && $JAVA_HOME/bin/java -jar /u01/$FMW_JAR -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" \
   && rm /u01/$FMW_JAR /u01/install.file \
   && rm -rf /u01/oracle/cfgtoollogs

VOLUME $VOLUME_DIR

ENV FMW_BIN=fmw_12.2.1.4.0_fr_linux64.bin \
    FMW_BIN2=fmw_12.2.1.4.0_fr_linux64-2.zip \
    VOLUME_DIR=/u01/oracle/user_projects

###### FORMS AND REPORTS
FROM fmw-infra AS formsreports
# HOST OS NGINX local repo trick
ARG REMOTE_REPO=http://172.17.0.1:8008

COPY formsreports.response oraInst.loc /opt/ora-reports-install/

RUN cd /opt/ora-reports-install \
   && wget --no-verbose --progress=bar "$REMOTE_REPO/$FMW_BIN" \
   && wget --no-verbose --progress=bar "$REMOTE_REPO/$FMW_BIN2" \
   && chmod +x $FMW_BIN \
   && ./$FMW_BIN -silent -responseFile /opt/ora-reports-install/formsreports.response  -invPtrLoc /opt/ora-reports-install/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation \
   && rm -f /opt/ora-reports-install/*

COPY --chown=oracle:root default-rcu-creation-scripts/* /opt/default-rcu-creation-scripts/
COPY --chown=oracle:root container-scripts/* /opt/container-scripts/

VOLUME $VOLUME_DIR
WORKDIR $ORACLE_HOME

# weblogic (/em and /console)
EXPOSE 7001

# FORMS
EXPOSE 9001
# REPORTS
EXPOSE 9002

ENTRYPOINT ["/bin/bash", "-c", "/opt/container-scripts/launcher.sh"]
