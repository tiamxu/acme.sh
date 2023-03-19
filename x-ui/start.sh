#!/bin/bash
docker run -itd --network=host \
    -v $PWD/db/:/etc/x-ui/ \
    -v $PWD/cert/:/root/cert/ \
    -v $PWD/logs/:/var/log/
    --name x-ui --restart=unless-stopped \
    enwaiax/x-ui:latest
