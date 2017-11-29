# jobsworth-installer
[Jobsworth](https://github.com/ari/jobsworth) installer and migrator from hosted [ClockingIT](http://www.clockingit.com/)

This project has the purpose of helping you install [jobsworth](https://github.com/ari/jobsworth) in an Ubuntu and Ubuntu Server OS, and also to help you migrate from the hosted verion of [ClockingIT](http://www.clockingit.com/)

At the moment the instructions are very raw, and the migration script might be unstable so be careful using it. You can choos to make an automatic install with the provided scripts or a Manual install following the steps detailed below.

## Automatic Installation of Jobsworth
You can install Jobsworth and also migrate your data if you wish, by using the scripts provided in this project.
The scripts will try to download and install everything you need.

### Instructions
To download the script and execute all you have to do is execute the following commands in the linux console:
```sh
wget https://github.com/frank-orellana/jobsworth-installer/archive/v0.3.1.tar.gz
tar xzf v0.3.1.tar.gz
cd jobsworth-installer-0.3.1
chmod +x install-jobsworth.sh
sudo ./install-jobsworth.sh
```

Follow the steps on screen and when everything is finished without errors you will be able to access your brand new installation of jobsworth in http://your-ip:8080/ with the user: `admin` and password: `password`. It might take a while the first time.

<details>
  <summary>Detailed instructions and details for automatic Install</summary>

All this scripts have been tested ONLY on new installations of Debian 8.8, Ubuntu 15.10, 16.04 and 16.10

There's also a VirtualBox VM ready to try if you wish to download it from [Dropbox](http://bit.ly/2niDqXL) with the instructions to use it [here](https://github.com/frank-orellana/jobsworth/releases): 

### Detailed instructions and details for automatic Install And/Or Data migration
1. Download the full project
1. Extract the files to a folder IN your server
1. Move to the `jobsworth-installer` directory
1. Make the file executable `chmod +x install-jobsworth.sh`
1. For **Installation** execute the file: `sudo ./install-jobsworth.sh`. 

The script will **automatically**:
 1. Download and install MySql (It will ask you to set the root password)
 1. Create a new database named `jobsworth` and a database user named `jw`
 1. Download, Install and configure Java JDK and Tomcat9
    1. You will be able to access tomcat welcome page at http://your-ip:8080/, and also the managemente addreses in http://your-ip:8080/host-manager and http://your-ip:8080/host-manager with the user and password `jobsworth` from your os and local network only.
        2. The installation path will be /opt/tomcat. For more details see the script
 1. Download, install and configure Jobsworth
 1. After the installation is complete you can access jobsworth through http://your-ip:8080/ with the user: `admin` and password: `password`. It might take a while the first time
1. For **Data Migration** view the instructions below
 
 To see the full details see the [Migration Guide](https://github.com/frank-orellana/jobsworth-installer/tree/master/migration-from-hosted)

The scripts need to be executable. If they are not you will have to execute this before trying to execute them:
```sh
chmod +x install-jobsworth.sh
chmod +x migration-from-hosted/migrate-from-hosted.sh
```

### Parameters of the script:
You can prevent parts of the script from executing like this:
`sudo NOXX=1 NOYY=1 ./install-jobsworth.sh`

The options you can prevent are:
<table>
<tr><th>OPTION</th><th>What it prevents</th></tr>
<tr><td>NO_UPD_REP</td><td>The update of repositories (apt-get update) for example for when you are running the script a second time</td></tr>
<tr><td>NO_DB_SERVER</td><td>The installation of mariadb-server</td></tr>
<tr><td>NO_DB</td><td>The creation of the jobsworth database</td></tr>
<tr><td>NO_JDK</td><td>The installation of openjdk-8-jdk</td></tr>
<tr><td>NO_TOMCAT</td><td>Tomcat download and installation</td></tr>
</table>

</details>

## Manual Installation of Jobsworth
If you do not wish to use the automatic installation script, there is also a tutorial to install jobsworth from scratch in a clean Ubuntu 16.10 Server & Desktop distro.

The full steps can be found in [here](https://github.com/frank-orellana/jobsworth-installer/wiki/Manual-installation).
<details>
<summary>Click here to view the steps required to manually install jobsworth</summary>

### Overview of the steps
Basically what you will do is:
1. Install Ubuntu 15.10 or above
2. Install and configure MariaDB (MySql)
3. Install and configure Java JDK 8
4. Install and configure Tomcat
5. Install and configure the Jobsworth WAR file

Full steps [here](https://github.com/frank-orellana/jobsworth-installer/wiki/Manual-installation).

Also there is a VM already configured if you prefer. You can download it from [dropbox](http://bit.ly/2niDqXL).
</details>

## Migration from Hosted ClockingIT
With these steps you should be able to migrate your projects, tasks, users and most of the data from the hosted version of ClockingIT to your installation of jobsworth. You need to have already installed jobsworth for this to work.
### Automatic migration steps
For the migration you will need to:
1. Download the full project, extract it in a folder IN your server
1. Go to the folder `jobsworth-installer/migration-from-hosted`
1. Download the sql dump from the hosted version of ClockingIT
1. Make the script executable `chmod +x migrate-from-hosted.sh`
1. Run the script as sudo passing as a parameter the dump file name: <br>  `sudo ./migrate-from-hosted.sh my_dump_file.sql`

All user's passwords will be reset to 'jobsworth'

The full steps for the migration can be found [here](https://github.com/frank-orellana/jobsworth-installer/tree/master/migration-from-hosted)

There might be some errors in the dump file, this has nothing to do with the current installer, and these errors will have to be fixed if necessary to import correctly.

----

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/FranklinOrellana)
