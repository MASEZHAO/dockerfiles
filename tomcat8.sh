export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export TOMCAT_HOME=/opt/tomcat8

case $1 in
start)
   sh $TOMCAT_HOME/bin/startup.sh
;;
stop)
   sh $TOMCAT_HOME/bin/shutdown.sh
;;
restart)
   sh $TOMCAT_HOME/bin/shutdown.sh
   sh $TOMCAT_HOME/bin/startup.sh
;;
esac
exit 0
