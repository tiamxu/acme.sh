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


# ubuntu系统初始化  
## 1.更新镜像源
```
cp /etc/apt/sources.list /etc/apt/sources.list_bak
sed -i 's/us.archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
```
## 2.安装docker
#### step 1: 安装必要的一些系统工具  
```
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
```
#### step 2: 安装GPG证书
```
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
```
#### Step 3: 写入软件源信息
```
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
```
#### Step 4: 更新并安装Docker-CE
```
sudo apt-get -y update
sudo apt-get -y install docker-ce
```
# nginx
容器起的nginx 代理一直报502，yum安装的没问题。
```
apt install nginx -y
```
使用acme申请免费证书，配置代理文件ss.conf

# x-ui
在面板添加xray日志

```
"log": {
    "access": "/var/log/access.log",
    "error": "/var/log/error.log",
    "loglevel": "warning"
},
```
通过nginx代理，此处x-ui面板可不用配置证书，将x-ui及xray监听地址设置127.0.0.1

# cloudflare配置
注册cloudflare账户，申请一个域名，将域名添加至cloudflare，并修改域名nameserver的dns地址为注册cloudflare里的地址。  
cloudflare为cdn加速
# 流程说明
使用cloudflare加速域名，将vps主机ip隐藏，  
nginx代理x-ui面板； nginx代理xray服务，

用户请求域名，实际请求流程为：  
test.xxx.com->cdn(443)->nginx(443)->xray(127.0.0.1:2906)  
test.xxx.com->cdn(443)->nginx(443)->x-ui(127.0.0.1:8443)

