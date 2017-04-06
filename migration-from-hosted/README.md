# MIGRATION GUIDE
This guide shows you the steps to migrate from the hosted [clockingIT](http://www.clockingit.com/) application to a local [jobsworth](https://github.com/ari/jobsworth/).

## 1. Download the scripts
First you need to download all the scripts included in this folder to your server.

## 2. Download a dump of your account
You have to download a sql dump of your account from the menu `Preferences -> Company Settings` and clicking in the button `Download Database Dump` save it in the same folder as the scripts

## 3. Create a temporary database
You will create a temporary database where you will store all the data you downloaded in the dump. 
To do this you can use the file called `schema.sql` in mysql using any user with all privileges (e.g. root)
````
mysql -u root -p < schema.sql
````

## 4. Import your dump
Now you have the schema created, you can import your data into it. If your dump is called my-clockingit-backup.sql, the you can execute:
````
mysql -u root -p clockingit < my-clockingit-backup.sql
````

## 5. Execute migration script
Execute the data-migration.sql file in my-sql. This will copy all the necessary data from the temporary clockingIT database to the jobsworth database.

If you named your josbsworth database something else, then you need to edit this file before migrating to set the correct name. By default the destination database is named `jobsworth`.

What the data-migration does is:
1. Resets the Default Company in jobsworth to be your company.
2. Creates all projects, clients, tasks, milestones, todos, worklogs, etc in the destination
3. Creates all the users from the origin in the destination resetting it's passwords

```bash
mysql -u root -p < data-migration.sql
```

## 6. Verify the imported data
Login to your account. You could even login with the users you had configured in clockingit, the password will be reset for all of them to `jobsworth` . If you had an user named `admin` in clockingIT, it will not be migrated.


## All together
Assuming you downloaded all your files in /tmp/
```bash
cd /tmp
mysql -u root -p < schema.sql
mysql -u root -p clockingit < my-clockingit-backup.sql
mysql -u root -p < data-migration.sql
```

## Known Issues
The script at the moment does not import:

    Some widgets

