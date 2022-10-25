# As root user
useradd --create-home --shell /bin/bash --groups sudo ubuntu 
passwd ubuntu # <password>

echo "ubuntu soft nofile 1000000" | tee -a /etc/security/limits.conf
echo "ubuntu hard nofile 1000000" | tee -a /etc/security/limits.conf

swapon -s # Confirm swap file/partition exists

echo -e "net.ipv4.tcp_tw_reuse='1'\nnet.ipv4.ip_local_port_range='1024 65000'\nnet.ipv4.tcp_fin_timeout='15'" >> /etc/sysctl.conf

su - ubuntu

# As ubuntu user
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
. /home/ubuntu/.nvm/nvm.sh
. /home/ubuntu/.bashrc

nvm install 14.20.0

npm install -g harperdb@3.3.0
harperdb install --TC_AGREEMENT yes --HDB_ROOT /home/ubuntu/hdb --SERVER_PORT 9901 --HDB_ADMIN_USERNAME HDB_ADMIN --HDB_ADMIN_PASSWORD '<password>' --HTTPS_ON true --CUSTOM_FUNCTIONS true --CUSTOM_FUNCTIONS_PORT 9902

crontab -l 2>/dev/null; echo "@reboot PATH=\"/home/ubuntu/.nvm/versions/node/v14.20.0/bin:$PATH\" && harperdb" | crontab -

exit

# As root user
apt-get update && apt-get upgrade -y
reboot now #Apply sysctl.conf settings, apply patches, verify that HarperDB started after reboot

# Add to Studio