# acme.sh
How To Automate SSL With Docker And NGINX
# Install
curl  https://get.acme.sh | sh
alias acme.sh=~/.acme.sh/acme.sh
acme.sh --set-default-ca  --server  letsencrypt
acme.sh --issue -d gopron.online -d test.gopron.online --nginx
acme.sh --install-cert -d gopron.online --key-file /etc/nginx/cert/key.pem --fullchain-file /etc/nginx/cert/cert.pem
