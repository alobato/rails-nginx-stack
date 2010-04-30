#!/bin/bash

echo "Automated VPS Setup for Ubuntu 10.04 LTS (Lucid) - Rails with Nginx"
echo "------------------------------------------------------------------"
echo ""


echo "Install Essencials"
echo "------------------------------------------------------------------"

sudo aptitude install build-essential -y
sudo aptitude install zlib1g-dev libreadline5-dev libssl-dev -y


echo "Install REE"
echo "------------------------------------------------------------------"

mkdir sources
cd sources
wget http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz
tar xzvf ruby-enterprise-1.8.7-2010.01.tar.gz
sudo ./ruby-enterprise-1.8.7-2010.01/installer --auto=/usr/local/ruby-enterprise
cd ..
rm -rf sources

sudo ln -s /usr/local/ruby-enterprise/bin/erb /usr/local/bin/erb
sudo ln -s /usr/local/ruby-enterprise/bin/gem /usr/local/bin/gem
sudo ln -s /usr/local/ruby-enterprise/bin/rackup /usr/local/bin/rackup
sudo ln -s /usr/local/ruby-enterprise/bin/rails /usr/local/bin/rails
sudo ln -s /usr/local/ruby-enterprise/bin/rake /usr/local/bin/rake
sudo ln -s /usr/local/ruby-enterprise/bin/rdoc /usr/local/bin/rdoc
sudo ln -s /usr/local/ruby-enterprise/bin/ree-version /usr/local/bin/ree-version
sudo ln -s /usr/local/ruby-enterprise/bin/ri /usr/local/bin/ri
sudo ln -s /usr/local/ruby-enterprise/bin/ruby /usr/local/bin/ruby
sudo ln -s /usr/local/ruby-enterprise/bin/testrb /usr/local/bin/testrb


echo "Install Passenger and Nginx"
echo "------------------------------------------------------------------"

sudo gem install passenger

sudo ln -s /usr/local/ruby-enterprise/bin/passenger-config /usr/local/bin/passenger-config
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-install-nginx-module /usr/local/bin/passenger-install-nginx-module
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-install-apache2-module /usr/local/bin/passenger-install-apache2-module
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-make-enterprisey /usr/local/bin/passenger-make-enterprisey
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-memory-stats /usr/local/bin/passenger-memory-stats
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-spawn-server /usr/local/bin/passenger-spawn-server
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-status /usr/local/bin/passenger-status
sudo ln -s /usr/local/ruby-enterprise/bin/passenger-stress-test /usr/local/bin/passenger-stress-test

sudo passenger-install-nginx-module --auto --auto-download --prefix=/usr/local/nginx

wget http://github.com/benschwarz/passenger-stack/raw/master/config/stack/nginx/init.d
sudo cp init.d /etc/init.d/nginx
rm init.d
sudo chmod +x /etc/init.d/nginx
sudo /usr/sbin/update-rc.d -f nginx defaults
sudo /etc/init.d/nginx start


echo "Install Git"
echo "------------------------------------------------------------------"

sudo aptitude install git-core -y


echo "Install MySQL"
echo "------------------------------------------------------------------"

# http://nagios.intuitinnovations.com/downloads/asterisk/asterisk1.4.2-A-install
# http://forum.slicehost.com/comments.php?DiscussionID=2187
# install MySQL non-interactively
# export DEBIAN_FRONTEND=noninteractive
# sudo aptitude -q -y install mysql-server
# unset DEBIAN_FRONTEND
# mysqladmin -u root password $mysqlpwd

sudo aptitude install mysql-server mysql-client libmysqlclient-dev -y

sudo gem install mysql --no-ri --no-rdoc


echo "Configure iptables"
echo "------------------------------------------------------------------"

# Para remover:
# sudo update-rc.d -f firewall remove

# http://stackoverflow.com/questions/850730/how-can-i-append-text-to-etc-apt-sources-list-from-the-command-line
sudo cat | sudo tee -a /etc/init.d/firewall <<ENDOFFILE
#!/bin/bash

iniciar(){

# Abre para a interface de loopback:
iptables -A INPUT -p tcp -i lo -j ACCEPT

# Bloqueia um determinado IP. Use para bloquear hosts especificos
#iptables -A INPUT -p ALL -s 88.191.79.206 -j DROP

# Abre as portas referentes aos servicos usados

# SSH:
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# DNS:
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

# HTTP e HTTPS:
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 7080 -j ACCEPT
#iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Bloqueia conexoes nas demais portas
iptables -A INPUT -p tcp --syn -j DROP

# Garante que o firewall permitira pacotes de conexoes ja iniciadas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Bloqueia as portas UDP de 0 a 1023 com excecao das abertas acima
iptables -A INPUT -p udp --dport 0:1023 -j DROP

# Para testar descomente. Ficara funcionando por 5 minutos
# sleep 300
# iptables -F
# iptables -P INPUT ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -X


# Drop all traffic to 127/8 that doesn't use lo0
#iptables -A INPUT -i ! lo -d 127.0.0.0/8 -j REJECT

# Allows all outbound traffic
# You can modify this to only allow certain traffic
#iptables -A OUTPUT -j ACCEPT

# Allow ping
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

# Allows SSH connections
# THE -dport NUMBER IS THE SAME ONE YOU SET UP IN THE SSHD_CONFIG FILE
#iptables -A INPUT -p tcp -m state --state NEW --dport 30000 -j ACCEPT

# Reject all other inbound - default deny unless explicitly allowed policy
#iptables -A INPUT -j REJECT
#iptables -A FORWARD -j REJECT

# log iptables denied calls
#iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

}
parar(){
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
}

case "\$1" in
"start") iniciar ;;
"stop") parar ;;
"restart") parar; iniciar ;;
*) echo "Use os parametros start ou stop"
esac
ENDOFFILE

sudo chmod +x /etc/init.d/firewall
sudo update-rc.d firewall defaults 99
sudo /etc/init.d/firewall start




echo "VPS Setup Complete"
echo "------------------------------------------------------------------"


