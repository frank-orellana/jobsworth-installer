#!/bin/bash

#This file is part of the jobsworth-installer program
#https://github.com/frank-orellana/jobsworth-installer
#Copyright (C) 2017  Franklin Orellana
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 3 of the License, or
#(at your option) any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software Foundation,
#Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
#WARNING:
#-This scrpit will overwrite info you may have on the jobsworth

echo "Starting installation..." 

pushd `dirname $0` > /dev/null
mydir=`pwd`
popd > /dev/null

logfile="$mydir/install.log"
echo "* logfile: $logfile"

if (( $EUID != 0 )); then
    echo 'ERROR: You dont have sudo rights. Execute the file like this: sudo install-jobsworth.sh' | tee $logfile
    exit
else
	echo '* Starting process...' | tee $logfile
fi

if [ -z "$NO_UPD_REP" ]; then
	echo "* Updating repositories..." | tee -a $logfile
	apt-get -qq update
fi

if [ -z "$NO_DB_SERVER" ]; then
	echo "* Installing mysql (MariaDB)" | tee -a $logfile

	echo "**   If it is not already installed it will ask you for a new password for "
	echo "**   the ROOT user. DON'T FORGET THAT PASSWORD!!!"
	echo "**   It will be asked later to create the default database"
	echo "**   If no password is requested the default password is blank"
	echo "** Downloading..."
	apt-get -qqy install mariadb-server | tee -a $logfile
else
	echo "** DB Server installation skipped" | tee -a $logfile
fi

if [ -z "$NO_DB" ]; then
	echo "** Creating Jobsworth database."
	echo "** Executing create-database.sql script... Enter mysql root password if asked" | tee -a $logfile
	mysql -u root -p < installer-resources/create-database.sql
	echo
	echo "******************************************************************************"
	echo "** Jobsworth database created. To access it you can type 'mysql -u jobsworth -p'" | tee -a $logfile
	echo "******************************************************************************"
else
	echo "** DB creation skipped" | tee -a $logfile
fi

echo

if [ -z "$NO_JDK" ]; then
	echo "* Installing JAVA" | tee -a $logfile

	JHF=$(update-java-alternatives -l | grep -o '/.*jvm/java-1.[89].*$')
	if [ -z "$JHF" ]; then
		java_available=$(apt-cache search openjdk-8-jdk)
		
		if [ -z "$java_available" ]; then
			echo "** JAVA package not available. Adding source http://http.debian.net/debian jessie-backports main" | tee -a $logfile
			echo deb http://http.debian.net/debian jessie-backports main >> /etc/apt/sources.list
			echo "** Updating repositories..." | tee -a $logfile
			apt-get -qq update
			echo "** Repositories updated" | tee -a $logfile
			
			echo "** Installing java openjdk-8-jdk..." | tee -a $logfile
			apt-get -qqy install -t jessie-backports  openjdk-8-jre-headless ca-certificates-java openjdk-8-jdk
		else
			echo "** openjdk-8-jdk is available to install"
			echo "** Installing java openjdk-8-jdk..." | tee -a $logfile
			apt-get -qqy install openjdk-8-jre-headless ca-certificates-java openjdk-8-jdk  | tee -a $logfile
		fi
		
		echo "** openjdk-8-jdk installed..." | tee -a $logfile

		JHF=$(update-java-alternatives -l | grep -o '/.*jvm/java-1.[89].*$')
		if [ -z "$JHF" ]; then 
			echo "* ERROR: JAVA_HOME Not Found. Exiting" | tee -a $logfile
			update-java-alternatives -l  | tee -a $logfile
			exit 
		else 
			echo "* JAVA_HOME FOUND: $JHF" | tee -a $logfile
			JHF=$JHF/jre
		fi
	else
		echo "** JAVA JDK 8 or 9 is already installed in $JHF" | tee -a $logfile
		JHF=$JHF/jre
	fi
else
	echo "** JDK Installation skipped" | tee -a $logfile
fi

if [ -z "$NO_TOMCAT" ]; then
	groupadd tomcat
	useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat | tee -a $logfile

	echo "* Downloading TOMCAT..." | tee -a $logfile
	cd $mydir
	wget --continue -nv http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz | tee -a $logfile

	echo "* TOMCAT dowloaded" | tee -a $logfile

	mkdir -p /opt/tomcat | tee -a $logfile
	tar -xzf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

	echo "* TOMCAT extracted" | tee -a $logfile

	echo "* Configuring TOMCAT..." | tee -a $logfile
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

	cd $mydir

	chmod +x installer-resources/configure-tomcat.sh | tee -a $logfile
	. ./installer-resources/configure-tomcat.sh


	echo "* TOMCAT has been installed. Please check its installation visiting http://localhost:8008 OR HTTP://<THIS_COMPUTER_IP>:8080 before continuing"
	read -n 1 -s -p "Press ENTER to continue"
else
	echo "** TOMCAT Installation skipped" | tee -a $logfile
fi

echo
echo "* Stopping TOMCAT"
systemctl stop tomcat

echo "* Downloading and Installing Jobsworth" | tee -a $logfile
cd /var
mkdir -p jobsworth/assets | tee -a $logfile

chown -R tomcat jobsworth
chgrp -R tomcat jobsworth
chmod -R 775 jobsworth

cd /opt/tomcat
rm -rf webapps/ROOT


echo "* Downloading WAR" | tee -a $logfile
cd $mydir
wget --continue -nv https://github.com/ari/jobsworth/releases/download/5.0b2/ROOT.war  | tee -a $logfile
echo "* WAR Downloaded" | tee -a $logfile
cp ROOT.war /opt/tomcat/webapps
cd /opt/tomcat/webapps
chown tomcat ROOT.war
chgrp tomcat ROOT.war

systemctl start tomcat
echo "* TOMCAT STATUS:" | tee -a $logfile
systemctl status tomcat | grep Active: | tee -a $logfile

chmod 664 /opt/tomcat/logs/*
echo
echo "******************************************************************************"
echo "******************************************************************************"
echo "JOBSWORTH HAS BEEN INSTALLED"  | tee -a $logfile
echo "THE INSTALLATION IS COMPLETE TYPE HTTP://LOCALHOST:8080 in the browser from "
echo "this computer OR HTTP://<THIS_COMPUTER_IP>:8080 FROM ANY OTHER"
echo "******************************************************************************"
echo "******************************************************************************"
echo 
