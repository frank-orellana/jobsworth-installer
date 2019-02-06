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

chmod +x ./installer-resources/configure-tomcat.sh | tee -a $logfile
. ./installer-resources/configure-tomcat.sh


echo "* TOMCAT has been configured. Please check its installation visiting http://localhost:8008 OR HTTP://<THIS_COMPUTER_IP>:8080 before continuing"

echo "* Downloading and Installing Jobsworth" | tee -a $logfile
cd /var
mkdir -p jobsworth/assets | tee -a $logfile

cd /usr/local/tomcat
rm -rf webapps/ROOT
cd $mydir

if [ ! -f ./installer-resources/ROOT.war ]
then
  echo "* ROOT.war not found in installer-resources...  Downloading" | tee -a $logfile
  cd ./installer-resources
  wget --continue -nv https://github.com/ari/jobsworth/releases/download/5.0b2/ROOT.war  | tee -a $logfile
  echo "* WAR Downloaded" | tee -a $logfile
  cd ..
fi

cp ./installer-resources/ROOT.war /usr/local/tomcat/webapps

echo
echo "******************************************************************************"
echo "******************************************************************************"
echo "JOBSWORTH HAS BEEN INSTALLED"  | tee -a $logfile
echo "THE INSTALLATION IS COMPLETE TYPE HTTP://<HOST>:8080 in the browser"
echo "******************************************************************************"
echo "******************************************************************************"
echo 