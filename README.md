# docker-for-sta426
This repo contains the `Dockerfile` recipe for building images that can run ARMOR.


# To build the image (just FYI; students don't need to do this)

```
# building the image
git clone https://github.com/sta426hs2022/docker-for-sta426.git
cd docker-for-sta426
docker build -t markrobinsonuzh/sta426:latest .

# if successful:
docker push markrobinsonuzh/sta426:latest
```

# Most important commands

```
# download image locally
docker pull markrobinsonuzh/sta426:latest

# start bash shell for testing from command line
docker run --it markrobinsonuzh/sta426:latest /bin/bash

# list local images
docker image ls

# run container with Rstudio; goto http://localhost:8886/ in browser
docker run -v /home/Shared/ece:/home/rstudio/work --restart unless-stopped --cpus 2 --memory 16GB -e PASSWORD=ZJ#m2X -p 8886:8787 markrobinsonuzh/sta426:latest

# list running containers (same as `docker ps` ?)
docker container ls

# login to already running container
docker exec -it <container name> /bin/bash
```

