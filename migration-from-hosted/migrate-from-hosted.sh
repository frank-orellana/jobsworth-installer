
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