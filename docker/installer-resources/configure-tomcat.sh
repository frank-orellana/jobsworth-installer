if [ -z "$logfile" ]; then
    pushd `dirname $0` > /dev/null
    mydir=`pwd`
    popd > /dev/null

    logfile="$mydir/configure-tomcat.log"
	
	echo "* logfile: $logfile" 
fi

echo "* Configuring TOMCAT SERVICE" | tee -a $logfile

system_memory=0
system_memory=$(grep MemTotal /proc/meminfo | awk '{print $2}')

if ((system_memory < 655360)); then
    newmem=256
    echo "* WARNING"                                                               | tee -a $logfile
    echo "** Your system has very low memory: $system_memory kb"                   | tee -a $logfile
    echo "** The configuration will try to set the java virtual machine to use "   | tee -a $logfile
    echo "** very little memory ($newmem MB). "                                    | tee -a $logfile

    export CATALINA_OPTS="-Xms$newmemM -Xmx$newmemM -server -XX:+UseParallelGC"
elif ((system_memory < 1310720)); then
    newmem=384
    echo "* WARNING"                                                               | tee -a $logfile
    echo "** Your system has low memory: $system_memory kb"                        | tee -a $logfile
    echo "** The configuration will try to set the java virtual machine to use "   | tee -a $logfile
    echo "** little memory ($newmem MB). "                                         | tee -a $logfile
    
    export CATALINA_OPTS="-Xms$newmemM -Xmx$newmemM -server -XX:+UseParallelGC"
else
	echo "** Server memory: $system_memory kb" | tee -a $logfile
	echo "** java VM memory: Xms512M Xmx1024M"

    export CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
fi

cp installer-resources/tomcat-context.xml /usr/local/tomcat/conf/context.xml
cp installer-resources/tomcat-users.xml /usr/local/tomcat/conf/
cp installer-resources/tomcat-managers-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
cp installer-resources/tomcat-managers-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

echo
echo "******************************************************************************"