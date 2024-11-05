#!/bin/bash
echo "[TASK 1] Zmiany SSH"
echo "Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 2] Dodanie usera"
sudo useradd -m -d /home/tematyka.it -s /bin/bash tematyka.it
sudo mkdir /home/tematyka.it/.ssh
sudo touch /home/tematyka.it/.ssh/authorized_keys
sudo chown -R tematyka.it:tematyka.it /home/tematyka.it/.ssh
sudo chmod 700 /home/tematyka.it/.ssh
sudo chmod 600 /home/tematyka.it/.ssh/authorized_keys
sudo usermod -a -G sudo tematyka.it
echo -e "Tematyka.it2024\nTematyka.it2024" | passwd tematyka.it

echo "[TASK 3] Aktualizacja + inne"
apt update && apt install -y curl gnupg apt-transport-https
timedatectl set-timezone Europe/Warsaw
timedatectl set-location Warsaw
apt-get install -y ntp
systemctl restart ntp
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list
apt update && apt install -y wazuh-agent
sed -i.bak 's/MANAGER_IP/192.168.60.10/' /var/ossec/etc/ossec.conf
systemctl enable wazuh-agent
systemctl start wazuh-agent