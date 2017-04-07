# jobsworth-installer
Jobsworth installer and migrator from ClockingIT

This project has the purpose of helping you install jobsworth in an Ubuntu and Ubuntu Server OS, and also to help you migrate from the hosted verion of clockingIT.

At the moment the instructions are very raw, and the migration script might be unstable so be careful using it.

## Installation of Jobsworth by scripts
You can install Jobsworth and also migrate your data if you wish, by using the scripts provided.
The scripts will try to download and install everything you need.

All this scripts have been tested ONLY on new installations of both Ubuntu Server and Desktop 16.10

There's also a VM ready to try if you wish to download it from [Dropbox](http://bit.ly/2niDqXL): 

### Instructions
1. Download the full project
1. Extract the file
1. Copy the all the files to a folder IN your server
1. Move to the `jobsworth-installer` directory
1. For installation execute the file: `sudo install-jobsworth-from-scratch.sh`. The script will
    1. Download and install MySql (It will ask you to set the root password)
    1. Create a new database named `jobsworth` and a user named `jw`
    1. Download, Install and configure Java and Tomcat9
        1. You will be able to access http://your-ip:8080/, http://your-ip:8080/host-manager and http://your-ip:8080/host-manager with the user and password `jobsworth` from your os and local network.
        2. The installation path will be /opt/tomcat. For mor details see the script
    4. Download, install and configure Jobsworth
        1. After the installation is complete you can access jobsworth through http://your-ip:8080/ with the user: `admin` and password: `password`. It might take a while the first time
1. For data migration execute the file `./migration-from-hosted/migrate-from-hosted.sh` passing as first argument yor backup file
    1. This will import all the data from a backup taken from your hosted version
    1. To see the full details see the [Migration Guide](https://github.com/frank-orellana/jobsworth-installer/tree/master/migration-from-hosted)

The scripts need to be executable. If they are not you will have to execute this before trying to execute them:
```bash
chmod 775 install-jobsworth-from-scratch.sh
chmod 775 migration-from-hosted/migrate-from-hosted.sh
```

## Manual Installation of Jobsworth
These tutorial will describe the steps to install jobsworth from scratch in a clean Ubuntu 16.10 Server & Desktop distro.

The full steps can be found in [here](https://github.com/frank-orellana/jobsworth/wiki/Jobsworth-5.0-beta-2-on-Ubuntu-Server-16.10).
### Overview of the steps
Basically what you will do is:
1. Install Ubuntu Server 16.10
2. Install and configure MySql
3. Install and configure Java
4. Install and configure Tomcat
5. Install and configure the Jobsworth WAR file

Also there is a VM already configured if you prefer. You can download it from [dropbox](http://bit.ly/2niDqXL).

## Migration from Hosted ClockingIT
With these steps you should be able to migrate your projects and tasks from the hosted version of ClockingIT to your installation of jobsworth. You need to have a database with the latest jobsworth schema for this to work.
### Overview of the steps
1. For the migration you will need to:
2. Download the dump from the hosted version of ClockingIT
3. Run the scripts to create a new database in your DB
4. Import the dump of the schema in the new database
5. Run the scripts to migrate the data

The full steps for the migration can be found [here](https://github.com/frank-orellana/jobsworth-installer/tree/master/migration-from-hosted)



----

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/FranklinOrellana)
