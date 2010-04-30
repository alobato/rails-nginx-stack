#!/bin/bash

echo "Automated VPS Setup for Ubuntu 10.04 LTS (Lucid) - Rails with Nginx"
echo "------------------------------------------------------------------"
echo ""
echo "Check if you enter password"
echo "---------------------------"
tmpvar=$1
mysqlpwd=$tmpvar
if [[ "$mysqlpwd" == "" ]] ; then
	clear
	echo "Exiting"
	echo "-------"
	echo "No MySQL password given"
	exit	
else
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


	echo "VPS Setup Complete"
	echo "------------------------------------------------------------------"

fi
