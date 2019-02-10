# Building and running docker image:

To build and run the docker image and run it you have to download this repo and execute docker-compose on the docker folder (You need to have docker and docker-compose already installed).

run:
```bash
wget https://github.com/frank-orellana/jobsworth-installer/archive/master.tar.gz
tar xzf master.tar.gz
cd jobsworth-installer-master/docker
docker-compose up --build -d
```

Then wait for the required components to download and for jobsworth to be installd automatically, and the you will be able to access jobsworth through http://localhost:8080 or http://your-vm-ip:8080

<details>
  The main files to build the images are the docker-compose.yml and the Dockerfile.

  ### docker-compose.yml 
  it has defined what images we will be using and building, in this case you can see we are using mariadb:latest official image and building another image called jobsworth:latest, which is built with the Dockerfile.

  ### Dockerfile
  With this file we are instructing docker to build an image based on the official tomcat image, and in that image we will download the latest jobsworth war file and install it.


</details>