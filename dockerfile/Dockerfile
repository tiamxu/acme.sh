FROM alpine:3.17

LABEL maintainer="nginx"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
	apk add --no-cache openssl tzdata curl ca-certificates tcpdump  busybox-extras nginx && \
	echo "Asia/Shanghai" > /etc/timezone && \
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone &&\
        rm -rf /var/www/localhost && rm -rf /etc/nginx && mkdir /var/www/html  &&\
        ln -sf /dev/stdout /var/log/nginx/access.log &&\
        ln -sf /dev/stderr /var/log/nginx/error.log 

COPY nginx /etc/nginx 
COPY run.sh /usr/sbin/run.sh


WORKDIR /var/www

EXPOSE 8080

STOPSIGNAL SIGQUIT

ENTRYPOINT ["run.sh"]
