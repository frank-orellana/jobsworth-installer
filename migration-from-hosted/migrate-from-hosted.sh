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

backup=$1

if [ -z "$backup" ]
  then
    echo You must specify a backup file:
	echo migrate-from-hosted.sh my_backup_file.sql
	exit
fi

if [ ! -f "$backup" ]; then
    echo Backup file not found: \"$backup\"
	echo You must spscify a valid backup file. Try entering the full path
	exit
fi

echo Starting migration with file: $backup

echo "******************************************************************************"
echo Creating clockingit database to load backup
echo
echo Please enter your MySql root password
mysql -u root -p < schema.sql
echo
echo Schema creation finalized. Please check if there has been any errors
echo "******************************************************************************"
read -n 1 -s -p "Press ENTER to continue"
echo
echo "******************************************************************************"
echo Loading backup into clockingit database
echo
echo Please enter your MySql root password
mysql -u root -p clockingit < $backup
echo
echo Data loaded. Please check if there has been any errors
echo "******************************************************************************"
read -n 1 -s -p "Press ENTER to continue"
echo
echo "******************************************************************************"
echo Migrating data from database clockingit to jobsworth
echo
echo Please enter your MySql root password
mysql -u root -p < data-migration.sql
echo
echo Schema creation finalized. Please check if there has been any
echo "******************************************************************************"
read -n 1 -s -p "Press ENTER to continue"
echo
echo "******************************************************************************"
echo Data migration finalized
echo "******************************************************************************"
