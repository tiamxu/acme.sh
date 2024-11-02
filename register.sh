#!/bin/bash
basepath=$(cd `dirname $0`;pwd)
cd $basepath
export ACMEDNS_BASE_URL="https://auth.acme-dns.io"
domain="template.cn"
challenge_file="${domain}-acme-dns.challenges"

curl -s -X POST ${ACMEDNS_BASE_URL}/register | python3 -m json.tool > $challenge_file;cat $challenge_file

export ACMEDNS_USERNAME="$(cat $challenge_file | awk -F"\"" '/username/{print $4}')"
export ACMEDNS_PASSWORD="$(cat $challenge_file | awk -F"\"" '/password/{print $4}')"
export ACMEDNS_SUBDOMAIN="$(cat $challenge_file | awk -F"\"" '/subdomain/{print $4}')"
echo "FULLDOMAIN = $(cat $challenge_file | awk -F"\"" '/fulldomain/{print $4}')"

