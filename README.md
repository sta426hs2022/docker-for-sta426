# docker-for-sta426
This repo contains the `Dockerfile` recipe for building images that can run [ARMOR](https://github.com/csoneson/ARMOR).

# To build the image (just FYI; students don't need to do this)

```
# building the image
git clone https://github.com/sta426hs2022/docker-for-sta426.git
cd docker-for-sta426
docker build -t markrobinsonuzh/sta426:latest .

# if successful:
docker push markrobinsonuzh/sta426:latest
```

# Install docker

One needs to install Docker; instructions are available for [Mac](https://docs.docker.com/desktop/install/mac-install/), [Linux](https://docs.docker.com/desktop/install/linux-install/) and [Windows](https://docs.docker.com/desktop/install/windows-install/).  


# Most important commands

```
# download image locally
docker pull markrobinsonuzh/sta426:latest

# start bash shell for testing from command line
docker run --it markrobinsonuzh/sta426:latest /bin/bash

# list local images
docker image ls

# run container with Rstudio; goto http://localhost:8886/ in browser (username: rstudio, password: as below)
# note the mapping of a local dir to that within container
docker run -v /Users/mark/projects/sta426_scratch:/home/rstudio/work --restart unless-stopped \
       --cpus 2 --memory 16GB -e PASSWORD=abc -p 8886:8787 markrobinsonuzh/sta426:latest

# list running containers (same as `docker ps` ?)
docker container ls

# login to already running container
docker exec -it <container name> /bin/bash
```

# Test that `ARMOR` is working

Goto [http://localhost:8886/](http://localhost:8886/) and type in username/password; RStudio Server should open. Go to Terminal and type:

```
cd /home/rstudio/work
git clone https://github.com/csoneson/ARMOR.git
cd ARMOR
snakemake --cores 1
```

