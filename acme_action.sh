#!/bin/bash
basepath=$(cd `dirname $0`;pwd)
cd $basepath
NAMESPACE=(a b c)
#domain="domain.cn"
domain=$1
dir="/etc/nginx/ssl"
for ns in ${NAMESPACE[@]};do
  echo $ns
  if [ "$domain" == "xx" ];then
    kubectl delete secret $domain -n $ns
    kubectl create secret tls $domain --key=${dir}/${domain}/${domain}.key --cert=${dir}/${domain}/${domain}.cer -n $ns
  fi
  if [ "$domain" == "xx" ];then
    ssh $ip "kubectl delete secret $domain -n $ns"
    ssh $ip kubectl create secret tls $domain --key=${dir}/${domain}/${domain}.key --cert=${dir}/${domain}/${domain}.cer -n $ns
  fi
done

