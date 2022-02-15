# Oracle Fusion Middleware (FMW Infrastructure) with Forms and Reports 12.2.1.0.4

## Problem

For legacy system, we still use Oracle Forms and Reports. As we would like to modernize our product, we wanted to update to the latest version. We were not able to find a working Docker images for Forms and Reports 12.2.1.0.4 that we can use to keep the product most recent as possible. On top of this, there is a lot of obsolete info given the Oracle has moved the images to private container repository.

## Solution

Based on great work by Dirk Nachbar (https://github.com/DirkNachbar/Docker), we have a working build with supplementary bootstrap scripts also to configure FMW via WLSL to create Forms and Reports servers. You need to download yourself installation files from Oracle, than in this repository there is a multi-stage build to create:

* ServerJDK image on top of official OracleLinux:8
* FMW Infrastructure image on top of ServerJDK
* Forms and Reports image on top of FMW Infrastructure

There is a docker-compose that allows you to build the image with all required dependencies. Dependencies are downloaded and installed in single step to keep the resulting docker image layer as small as possible. This combination of version is certified according to the Oracle compatiblity matrix (https://www.oracle.com/middleware/technologies/fusion-certification.html).

## HOWTO

- Get a account for Oracle Edelivery for downloading licensed installation files (https://edelivery.oracle.com/osdc/faces/Home.jspx)

- Following files needs to be downloaded from Edelivery and unzipped to folder installation-files/ . There is also a WGET scripts prepared (you just input your username and password on second line), but we are not sure, how long this will work.

|Resource                           | Filename in installation-files/   | Edelivery search name     |  WGET script |
|---                                |---                                |---                        |---|
|Oracle JDK                         | jdk-8u321-linux-x64.tar.gz        | Oracle JDK 1.8.0_321      | installation-files/wget-jdk-8u321.sh  |
|Fusion Middleware - Infrastructure | fmw_12.2.1.4.0_infrastructure.jar | Oracle Fusion Middleware 12c Infrastructure 12.2.1.4.0 | installation-files/wget-fmw-infra-12.2.1.4.sh  |
|Forms and Reports                  | fmw_12.2.1.4.0_fr_linux64.bin, fmw_12.2.1.4.0_fr_linux64-2.zip  |  Oracle Forms and Reports 12.2.1.4.0 ( Oracle Forms and Reports )		 |  installation-files/wget-fr-12.2.1.4.sh |

 - For the easiest possible build, there are also prepared WGET download scripts in ./installation-files.


    cd ./installation-files
    # run each wget one by one, input login and password
    ./unzip-all.sh


 - Run nginx for serving these resources (this step save you A LOT of time when you rebuild over and over the main Dockerfile - large files are not transferred again and again to Docker daemon).


    docker-compose -f docker-compose.build.yml up -d

 
- Configuration can be done in following file. Of course, part of this file you can later and mount this file into container.


    ./OracleForms/container-scripts/setenv.sh


- Build the Forms and Reports image


    docker-compose build

- You can tag the result image and use it

## Run the generated image

- There is also a docker-compose with the Oracle DB configured for testing (DB is required for RCU (Repository Creation Utility) and the RCU will drop and than create the repository on the first run). To download the Oracle DB image, you first need to sign in to [Oracle Container Registry](https://container-registry.oracle.com/ords/f?p=113:4:107491460743651:::4:P4_REPOSITORY,AI_REPOSITORY,AI_REPOSITORY_NAME,P4_REPOSITORY_NAME,P4_EULA_ID,P4_BUSINESS_AREA_ID:9,9,Oracle%20Database%20Enterprise%20Edition,Oracle%20Database%20Enterprise%20Edition,1,0&cs=3sFQ_XbKSEnH85nKYJKhHGfnE4VsqoQKiHXEIh6SrTf7_8F5tTiR-ceAG3Pzrrt6HwYJGD0TSbtqasa-xVJYH0g) and confirm the license. Docker login using your credentials later on:


      docker login container-registry.oracle.com
      # Otherwise you will get these errors: ERROR: Head https://container-registry.oracle.com/v2/database/enterprise/manifests/19.3.0.0: unauthorized: authentication required

      # start the database seprately
      docker-compose start oradb
      # wait like 15 mins to fully initialize, check status via
      docker-compose logs -f
      # wait for this message in the db log: DATABASE IS READY TO USE!
      
      # set default password for user:
      docker exec -it oracle-fmw-forms-and-reports_oradb_1 bash
      ./setPassword.sh XXXX
      # you use the same password in ./OracleForms/container-scripts/setenv.sh later on

      # if the DB is online, start the Forms and Reports
      # note - image is constructed to do the necessary setup on the first run and exist afterwars
      # wait intervals are defined as fixed, BUT sometimes there are not enough, depending on the load of the server
      docker-compose start formsreports
      # first run takes 7-10 mins, after this, it should

      # start again and this time it should be working ok
      docker-compose start formsreports

      # weblogic is fully started with this message in the logs: <Server state changed to RUNNING.>

      # currently, there are 3 services, only 1 starts automatically (weblogic admin console and enterprise manager):
      http://localhost:7001/em  
      # or
      http://localhost:7001/console
      # use can use these (default: weblogic/welcome1) to start MS_FORMS and MS_REPORTS
      # or you can use standard start scripts

      # check working FORMS here:
      http://localhost:9011/forms/frmservlet (blank screen with title and without 404 error means OK, port is remapped from default 9001 in docker-compose.yml)
      http://localhost:9012/reports/rwservlet (port remapped in docker-compose.yml from default 9002)


### Reseting the domain

- To reset the already initialized domain, from forms container or outside:


      rm -r /u01/oracle/user_projects/domains/$DOMAIN_NAME/  
      
