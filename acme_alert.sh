#!/bin/bash
basepath=$(cd `dirname $0`;pwd)
cd $basepath
echo "############### `date '+%F %T'` ###################"
# 域名
domain_list=(template.com template.cn)

alert_type="feishu"
#飞书webhook
feishu_url="https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxx"

# 提前5天开始提醒
alam_before_day=$((5*24*60*60))

# 到最后1天还未更新证书则强制更
force_update_before_day=$((1*24*60*60))
  

function getremaintime()
{
  expire_date_utc=`/root/.acme.sh/acme.sh --list | grep ${domain} | awk '{print $6}' `
  expire_time=`date -d "${expire_date_utc}" +"%s"`
  now_time=`date +"%s"`
  remain_time=`expr $expire_time - $now_time`
}

# alerts
function alert(){
  alert_msg=$1
  if [ $alert_type == "feishu" ];then
    curl -X POST  -H 'Content-Type: application/json' -d "{\"msg_type\": \"text\",\"content\":{\"text\": \"${alert_msg}\"}}" "${feishu_url}"
  fi
}

for domain in ${domain_list[@]} ;do
  echo "`date '+%F %T'` $domain 开始执行检测..."
  getremaintime

  if [ $remain_time -lt $alam_before_day ]; then
    #/root/.acme.sh/acme.sh --renew --dns dns_acmedns -d $domain -d *.$domain --server letsencrypt --use-wget --days 90 -k 2048 --force
    sh ${domain}.sh
    getremaintime
    remain_day=`expr $remain_time / 24 / 60 / 60`
    if [ $remain_time -lt $alam_before_day ]; then
      msg="通知告警:${domain}域名ssl证书即将过期，续签失败，请尽快人工干预，剩余时间：${remain_day}天"
    else
      msg="通知告警:${domain}域名ssl证书即将过期，已续签成功，剩余时间：${remain_day}天"
      #这里写需要执行的操作
      [ -f /usr/share/nginx/downloads/${domain}.tar.gz ] && rm -f /usr/share/nginx/downloads/${domain}.tar.gz
      tar czf /usr/share/nginx/downloads/${domain}.tar.gz ./${domain}
    fi
    alert $msg 
  fi
  echo "`date '+%F %T'` $domain 执行检测结束..."
done
