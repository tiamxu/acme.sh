#!/bin/bash
basepath=$(cd `dirname $0`;pwd)
cd $basepath
export ACMEDNS_BASE_URL="https://auth.acme-dns.io"
domain="template.cn"
challenge_file="${domain}-acme-dns.challenges"

#curl -s -X POST ${ACMEDNS_BASE_URL}/register | python3 -m json.tool > $challenge_file;cat $challenge_file

export ACMEDNS_USERNAME="$(cat $challenge_file | awk -F"\"" '/username/{print $4}')"
export ACMEDNS_PASSWORD="$(cat $challenge_file | awk -F"\"" '/password/{print $4}')"
export ACMEDNS_SUBDOMAIN="$(cat $challenge_file | awk -F"\"" '/subdomain/{print $4}')"
echo "FULLDOMAIN = $(cat $challenge_file | awk -F"\"" '/fulldomain/{print $4}')"

#./acme.sh --issue --dns dns_acmedns -d $domain -d *.$domain --server letsencrypt --use-wget --days 90 -k 2048

expire_date_utc=`/root/.acme.sh/acme.sh --list | grep ${domain} | awk '{print $6}'`
if [ -z $expire_date_utc ];then
   echo "`date '+%F %T'` 申请证书${domain}"
   /root/.acme.sh/acme.sh --issue --dns dns_acmedns -d $domain -d *.$domain --server letsencrypt --use-wget --days 90 -k 2048
else
   echo "`date '+%F %T'` 更新证书${domain}"
   /root/.acme.sh/acme.sh --renew --dns dns_acmedns -d $domain -d *.$domain --server letsencrypt --use-wget --days 90 -k 2048 --force
fi
