> acme.sh是一个基于Shell脚本编写的开源项目，用于获取SSL/TLS证书，可以实现自动申请、续签、安装证书，让网站实现https访问
在最新的 v3.x.x 版本中，acme.sh已经将默认CA切换到 ZeroSSL ，具体原因可见官方Wiki，相比于此前的 Let's Encrypt ，它可以在线查看证书状态，且根证书对老设备兼容性更好，不过免费版账号只能同时申请3张证书，执行 acme.sh --set-default-ca --server letsencrypt 命令可切换为原先的CA

# 安装 acme.sh
```
方法1：
git clone https://github.com/acmesh-official/acme.sh.git
cd ./acme.sh
./acme.sh --install -m example@example.com
方法2：
curl https://get.acme.sh | sh -s email=my@example.com
or
wget -O -  https://get.acme.sh | sh -s email=my@example.com
```

# 使用DNS方式生产证书
dns方式有手动和自动两种方式，手动 dns 方式, 手动在域名上添加一条 txt 解析记录, 验证域名所有权。

常用的dns api: 
`
https://github.com/acmesh-official/acme.sh/wiki/dnsapi
`

acme-dns不支持dns接口的dns 可以使用此，有公用服务器
`https://github.com/joohoi/acme-dns`
## 公共acme-dns使用步骤
### acme-dns注册用户
```
export ACMEDNS_BASE_URL="https://auth.acme-dns.io"
curl -s -X POST ${ACMEDNS_BASE_URL}/register | python3 -m json.tool > acme-dns.challenges;cat acme-dns.challenges 
export ACMEDNS_USERNAME="$(cat acme-dns.challenges | awk -F"\"" '/username/{print $4}')"
export ACMEDNS_PASSWORD="$(cat acme-dns.challenges | awk -F"\"" '/password/{print $4}')"
export ACMEDNS_SUBDOMAIN="$(cat acme-dns.challenges | awk -F"\"" '/subdomain/{print $4}')"
echo "FULLDOMAIN = $(cat acme-dns.challenges | awk -F"\"" '/fulldomain/{print $4}')"
```
### 添加dns解析
前往域名管理控制台，添加一行dns解析用于验证dns

如：我的域名是 gopron.cn，我想申请gopron.cn或者*.gopron.cn的证书解析如 例1

如：我的域名是 gopron.cn 我想申请www.gopron.cn的证书解析如例2

|例	|    主机记录	| 记录类型	| 记录值为2中申请的fulldomain|
:---: |    :------:     | :--------:  | :------------------------:  |
|例1 |	_acme-challenge|	CNAME|	13b0f345-279d-4f8e-a198-fe0b94f70ed2.auth.acme-dns.io|
|例2 |	_acme-challenge.www|	CNAME|	13b0f345-279d-4f8e-a198-fe0b94f70ed2.auth.acme-dns.io|
### 检测 CNAME 正确
```
dig CNAME _acme-challenge.gopron.cn
dig TXT _acme-challenge.gopron.cn
```
### 申请证书
> 申请过程中报错： Please refer to https://curl.haxx.se/libcurl/c/libcurl-errors.html for error code: 35
添加参数使用--use-wget,或者添加export ACME_USE_WGET=1

```
./acme.sh --issue --dns dns_acmedns -d gopron.cn -d *.gopron.cn --server letsencrypt --use-wget --days 90 -k 2048
```
注：申请泛域名证书需要指定两个domain：domain.com 和*.domain.com
