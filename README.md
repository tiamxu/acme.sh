# acme.sh
How To Automate SSL With Docker And NGINX
# docker build
```
cd dockerfile
docker build -t nginx .
```
# Install
#### ACME安装
```
curl  https://get.acme.sh | sh
```

#### 设置命令别名
```
ln -s ~/.acme.sh/acme.sh /usr/bin/acme.sh
```
#### 更改默认证书
```
acme.sh --set-default-ca  --server  letsencrypt
```
默认需要设置邮箱  

#### 生成证书
```
acme.sh --issue -d gopron.online -d test.gopron.online --nginx
```
#### 安装证书
```
acme.sh --install-cert -d gopron.online --key-file /etc/nginx/cert/key.pem --fullchain-file /etc/nginx/cert/cert.pem
```
# docker run
```
cd /mnt/nginx
sh start.sh
```
