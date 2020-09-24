
#Dont Forget to enter below fields 
HOSTNAME="custom-domain-name-here"
EMAIL="your-email-address-here"

# set hostname
hostnamectl set-hostname $HOSTNAME
echo -e "127.0.0.1 localhost $HOSTNAME" >> /etc/hosts

# download and adding jitsi to source
wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add -
sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"
apt update 
echo -e "DefaultLimitNOFILE=65000\nDefaultLimitNPROC=65000\nDefaultTasksMax=65000" >> /etc/systemd/system.conf
systemctl daemon-reload

# Configure Jits install
debconf-set-selections <<< $(echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string '$HOSTNAME)
debconf-set-selections <<< 'jitsi-meet-web-config   jitsi-meet/cert-choice  select  "Generate a new self-signed certificate"';

# Install Jitsi 
apt install -y jitsi-meet

# installing the certificate from letsencrypt
echo $EMAIL | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh