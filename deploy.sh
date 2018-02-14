##Author Thanos Zakopoulos
##v.1.1 Added rm for old wars. Keep only last 5

#!bin/bash
DATE=`date '+%m%d%Y.%H%M'`
TOMCAT_HOME=/usr/share/tomcat7
WEBAPP_HOME=/usr/share/tomcat7/webapps
WAR_FILE=myportal.war
##stop tomcat
sudo su - root -c "/etc/init.d/tomcat7 stop"

##check if tomcat indeed stopped.otherwise exit and print to terminal "tomcat not stopped
sudo su - root -c "/etc/init.d/tomcat7 status"

status="$?"

if [ "$status" = "0" ]
then
echo "Check if tomcat is stopped"
exit 1
fi


##backup old war
sudo su - root -c "cp -p $WEBAPP_HOME/$WAR_FILE $WEBAPP_HOME/$WAR_FILE.$DATE"


##delete webapps/myportal,work
sudo su - root -c "rm -rf $TOMCAT_HOME/work/Catalina/localhost/myportal/"
sudo su - root -c "rm -rf $TOMCAT_HOME/temp/"
sudo su - root -c "rm -rf $WEBAPP_HOME/myportal/"
sudo su - root -c "rm -rf $WEBAPP_HOME/$WAR_FILE"

## copy new war
sudo su - root -c "cp -p  /home/ec2-user/$WAR_FILE $WEBAPP_HOME/

##start tomcat
sudo su - root -c "/etc/init.d/tomcat7 start"

##check if deployment is succesfull after waiting for 30 seconds
sleep 30
curl http://localhost:8080/myportal
status1="$?"

if [ "$status1" != "0" ]
then
echo "Check if myportal deployment is successful"
exit 1
fi


###keep only last five war backups
OLD_WAR_COUNT=$(ls $WEBAPP_HOME/$WAR_FILE.*|wc -l)
if [ $OLD_WAR_COUNT -gt 5 ] ;then diff=$(($OLD_WAR_COUNT-5));ls -t $WEBAPP_HOME/$WAR_FILE.*|tail -$diff|xargs rm -f;fi
