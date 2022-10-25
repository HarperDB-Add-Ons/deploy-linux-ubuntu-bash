# Setup HarperDB on an Ubuntu Server

## How to Setup HarperDB on an Ubuntu Server

To prepare the server and install HarperDB, run the `setup.sh` script as the root user.

The commands in the script are documented below.

### Setup Steps

### Create User

As a **root user** run the following.

```
useradd --create-home --shell /bin/bash --groups sudo ubuntu
passwd ubuntu # <password>
```

### Increase Number of Open Files for User

```
echo "ubuntu soft nofile 1000000" | tee -a /etc/security/limits.conf
echo "ubuntu hard nofile 1000000" | tee -a /etc/security/limits.conf
```

### Ensure Swap is Enabled

```
swapon -s # Confirm swap file/partition exists
```

### Increase Number of Allowed Network Connections

```
echo -e "net.ipv4.tcp_tw_reuse='1'\nnet.ipv4.ip_local_port_range='1024 65000'\nnet.ipv4.tcp_fin_timeout='15'" >> /etc/sysctl.conf

su - ubuntu
```

### Install Node

As **ubuntu user** run the following.

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
. /home/ubuntu/.nvm/nvm.sh
. /home/ubuntu/.bashrc

nvm install 14.20.0
```

### Install HarperDB

```
npm install -g harperdb@3.3.0
harperdb install --TC_AGREEMENT yes --HDB_ROOT /home/ubuntu/hdb --SERVER_PORT 9925 --HDB_ADMIN_USERNAME HDB_ADMIN --HDB_ADMIN_PASSWORD 'ADD_PASSWORD_HERE!' --HTTPS_ON true --CUSTOM_FUNCTIONS true --CUSTOM_FUNCTIONS_PORT 9926
```

### Add to Crontab for Reboot

```
crontab -l 2>/dev/null; echo "@reboot PATH=\"/home/ubuntu/.nvm/versions/node/v14.20.0/bin:$PATH\" && harperdb" | crontab -
```

### Update and Restart

```
exit # to return to root user

apt-get update && apt-get upgrade -y
reboot now # Apply sysctl.conf settings, apply patches, verify that HarperDB started after reboot
```

### Add Instance in Studio

Go to the [HarperDB Studio](https://studio.harperdb.io/) and add the instance.
