if [ -z "$logfile" ]; then
    pushd `dirname $0` > /dev/null
    mydir=`pwd`
    popd > /dev/null

    logfile="$mydir/configure-tomcat.log"
	
	echo "* logfile: $logfile" 
fi

echo "* Configuring TOMCAT SERVICE" | tee -a $logfile
sed "s|{YOUR_JAVA_HOME}|$JHF|g" installer-resources/tomcat.service.ini > /etc/systemd/system/tomcat.service

system_memory=0
system_memory=$(grep MemTotal /proc/meminfo | awk '{print $2}')

if ((system_memory < 655360)); then
    newmem=256
    echo "* WARNING"                                                               | tee -a $logfile
    echo "** Your system has very low memory: $system_memory kb"                   | tee -a $logfile
    echo "** The configuration will try to set the java virtual machine to use "   | tee -a $logfile
    echo "** very little memory ($newmem MB). You can change this setting later"   | tee -a $logfile
    echo "** in the file /etc/systemd/system/tomcat.service"                       | tee -a $logfile
    
    sed -i "s|Xms512M|Xms""$newmem""M|g" /etc/systemd/system/tomcat.service
    sed -i "s|Xmx1024M|Xmx""$newmem""M|g" /etc/systemd/system/tomcat.service
elif ((system_memory < 1310720)); then
    newmem=384
    echo "* WARNING"                                                               | tee -a $logfile
    echo "** Your system has low memory: $system_memory kb"                        | tee -a $logfile
    echo "** The configuration will try to set the java virtual machine to use "   | tee -a $logfile
    echo "** little memory ($newmem MB). You can change this setting later"        | tee -a $logfile
    echo "** in the file /etc/systemd/system/tomcat.service"                       | tee -a $logfile
    
    sed -i "s|Xms512M|Xms""$newmem""M|g" /etc/systemd/system/tomcat.service
    sed -i "s|Xmx1024M|Xmx""$newmem""M|g" /etc/systemd/system/tomcat.service
else
	echo "** Server memory: $system_memory kb" | tee -a $logfile
	echo "** java VM memory: Xms512M Xmx1024M"
fi

cp installer-resources/tomcat-context.xml /opt/tomcat/conf/context.xml
cp installer-resources/tomcat-users.xml /opt/tomcat/conf/
cp installer-resources/tomcat-managers-context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
cp installer-resources/tomcat-managers-context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml

echo "* adding user $SUDO_USER to group tomcat" | tee -a $logfile
if [ -z "$SUDO_USER" ]; then
	echo "** WARNING: Current user could not be detected and added to group. Are you executing with root instead of sudo?" | tee -a $logfile
else
    usermod -a -G tomcat $SUDO_USER | tee -a $logfile
fi


systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

ufw allow 8080

echo "* TOMCAT STATUS:" | tee -a $logfile
systemctl status tomcat | grep Active: | tee -a $logfile
echo
echo "******************************************************************************"