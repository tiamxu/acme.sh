#!/bin/bash
 docker run -itd  --network=host --name nginx \
	 -v /etc/localtime:/etc/localtime \
	 -v /mnt/nginx/.acme.sh:/root/.acme.sh \
	 -v /mnt/nginx/config/conf.d:/etc/nginx/conf.d \
	 -v /mnt/nginx/config/cert:/etc/nginx/cert \
	 -v /mnt/nginx/data:/var/www/html -v /mnt/nginx/logs:/var/log/nginx  nginx:latest
