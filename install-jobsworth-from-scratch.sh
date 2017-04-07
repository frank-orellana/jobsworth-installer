#!/bin/bash

echo "Starting installation..." 

pushd `dirname $0` > /dev/null
mydir=`pwd`
popd > /dev/null

logfile=$mydir/install.log

if sudo -S -p '' echo -n < /dev/null 2> /dev/null; then echo 'Starting Installation...' >> logfile ; else echo 'ERROR: You dont have sudo rights. Execute the file like this: sudo install-jobsworth-from-scratch.sh' | tee logfile ; exit ; fi

apt-get -qq update

echo "* Installing MySQL" | tee -a logfile

echo "*   If it is not already installed it will ask you for a new password for "
echo "*   the ROOT user. DON'T FORGET THAT PASSWORD!!!"
echo "*   It will be asked later to create the default database"
echo "* Downloading..."
apt-get -qqy install mysql-server

echo "* Creating Jobsworth database. Enter MySql root password: "

echo "* Executing create-database.sql script..." | tee -a logfile
mysql -u root -p < installer-resources/create-database.sql
echo
echo "******************************************************************************"
echo "* Jobsworth database created. To access it you can type 'mysql -u jobsworth -p'" | tee -a logfile
echo "******************************************************************************"
echo
echo "* Installing JAVA" | tee -a logfile
apt-get -qqy install default-jdk

JHF=$(update-java-alternatives -l | grep -o '/.*jvm/java-.*$')/jre
if [ -z "$JHF" ]; then echo "* ERROR: JAVA_HOME Not Found. Exiting" | tee -a logfile; exit; else echo "* JAVA_HOME FOUND: $JHF" | tee -a logfile; fi

groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
usermod -a -G tomcat $USER 

cd /tmp

echo "* Downloading TOMCAT..." | tee -a logfile
wget -q -nc http://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.0.M19/bin/apache-tomcat-9.0.0.M19.tar.gz >> logfile

echo "* TOMCAT dowloaded" | tee -a logfile

mkdir /opt/tomcat
tar -xzf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1

echo "* TOMCAT extracted" | tee -a logfile

echo "* Configuring TOMCAT..." | tee -a logfile
cd /opt/tomcat
chgrp -R tomcat /opt/tomcat
chmod -R g+r conf
chmod g+x conf
chown -R tomcat webapps/ work/ temp/ logs/
chmod 775 -R conf/ logs/ webapps/

cd conf
find . -type f -exec chmod 664 -- {} +

cd ../webapps
find . -type f -exec chmod 664 -- {} +

#sudo nano /etc/systemd/system/tomcat.service
# wget https://raw.githubusercontent.com/frank-orellana/jobsworth-installer/master/installer-resources/tomcat.service.ini

cd $mydir

echo "* Configuring TOMCAT SERVICE" | tee -a logfile
sed "s|{YOUR_JAVA_HOME}|$JHF|g" installer-resources/tomcat.service.ini > /etc/systemd/system/tomcat.service
cp installer-resources/tomcat-context.xml /opt/tomcat/conf/context.xml
cp installer-resources/tomcat-users.xml /opt/tomcat/conf/
cp installer-resources/tomcat-managers-context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
cp installer-resources/tomcat-managers-context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

sudo ufw allow 8080

echo "* TOMCAT STATUS:" | tee -a logfile
systemctl status tomcat | grep Active: | tee -a logfile
echo
echo "******************************************************************************"
echo "* TOMCAT has been installed. Please check its installation visiting http://localhost:8008 OR HTTP://<THIS_COMPUTER_IP>:8080 before continuing"
read -n 1 -s -p "Press ENTER to continue"
echo
echo "* Stopping TOMCAT"
systemctl stop tomcat
#sudo nano /opt/tomcat/conf/tomcat-users.xml
# sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
# wget https://raw.githubusercontent.com/frank-orellana/jobsworth-installer/master/installer-resources/tomcat-context.xml
# wget https://raw.githubusercontent.com/frank-orellana/jobsworth-installer/master/installer-resources/tomcat-managers-context.xml
# wget https://raw.githubusercontent.com/frank-orellana/jobsworth-installer/master/installer-resources/tomcat-managers-context.xml


echo "* Downloading and Installing Jobsworth" | tee -a logfile
cd /var
mkdir -p jobsworth/assets

chown -R tomcat jobsworth
chgrp -R tomcat jobsworth
chmod -R 775 jobsworth

cd /opt/tomcat
rm -rf webapps/ROOT

cd /opt/tomcat/webapps
echo "* Downloading WAR" | tee -a logfile
wget -q -nc https://github.com/ari/jobsworth/releases/download/5.0b2/ROOT.war
echo "* WAR Downloaded" | tee -a logfile
chown tomcat ROOT.war
chgrp tomcat ROOT.war

systemctl start tomcat
echo "* TOMCAT STATUS:" | tee -a logfile
systemctl status tomcat | grep Active: | tee -a logfile

chmod 664 /opt/tomcat/logs/*
echo
echo "******************************************************************************"
echo "******************************************************************************"
echo "JOBSWORTH HAS BEEN INSTALLED"  | tee -a logfile
echo "THE INSTALLATION IS COMPLETE TYPE HTTP://LOCALHOST:8080 in the browser from "
echo "this computer OR HTTP://<THIS_COMPUTER_IP>:8080 FROM ANY OTHER"
echo "******************************************************************************"
echo "******************************************************************************"
echo 