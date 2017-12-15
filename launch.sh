#!/bin/sh

docker stop fsquid
docker rm fsquid

docker run -d --name fsquid -v /var/log/squid:/var/log/squid -p 193.205.66.177:3128:3128 --net host  --hostname one-services.to.infn.it svallero/fsquid
