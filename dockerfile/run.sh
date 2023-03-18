#!/bin/sh

if [ -f /var/run/secrets/kubernetes.io/serviceaccount/namespace ];then
   MY_POD_NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`
   export MY_POD_NAMESPACE
fi


ln -fs `which nginx` /usr/local/bin/`ls *.dist 2&>/dev/null`
test   -f /sys/fs/cgroup/cgroup.controllers   || count=`expr $(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us) / $(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us) 2> /dev/null`
test ! -f /sys/fs/cgroup/cgroup.controllers   || count=`expr $(cat /sys/fs/cgroup/cpu.max|cut -d " " -f1) / $(cat /sys/fs/cgroup/cpu.max|cut -d " " -f2) 2>/dev/null`
#
test   -f /sys/fs/cgroup/cgroup.controllers   || size=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
test ! -f /sys/fs/cgroup/cgroup.controllers   || size=$(cat /sys/fs/cgroup/memory.max)

if [ "$count" == "" ] || [ "$count" == 0 ];then
      count=auto
fi
if [ "$size" == "max" ];then
      size=`expr $(grep MemAvailable /proc/meminfo|awk '{print $2}') / 1024`
fi

WORKER_PROCESSES_SIZE=${WORKER_PROCESSES_SIZE:-$count}
WORKER_CONNECTIONS_SIZE=${WORKER_CONNECTIONS_SIZE:-65535}
HTTP_PORT=${HTTP_PORT:-8080}

sed -i "s/worker_processes *.*;/worker_processes $WORKER_PROCESSES_SIZE;/"       /etc/nginx/nginx.conf
sed -i "s/worker_connections *.*;/worker_connections $WORKER_CONNECTIONS_SIZE;/" /etc/nginx/nginx.conf
sed -i "s/listen 80 default_server;/listen $HTTP_PORT default_server;/"   	 /etc/nginx/conf.d/default.conf 2&>/dev/null


bin=`ls *.dist 2&>/dev/null`
bin=${bin:-nginx}

if [ "$PROXY_PORT" == "" ];then
   echo "daemon off;" >> /etc/nginx/nginx.conf 
   exec $bin
else
   if [ "$#" == 0 ];then
      exit 0
   fi

   $bin
   exec "$@"
fi
