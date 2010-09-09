Deploy no Linode
================

1. Instale uma distribuição Linux
---------------------------------
[Referência](http://library.linode.com/linode-manager/deploying-a-linux-distribution)

Entre no painel de controle do [Linode](www.linode.com) e faça o login.  
Acesse: Linode Manager | Dashboard | Deploy a Linux Distribution  
Escolha a distribuição Ubuntu 10.04 LTS e defina a senha do Root.  
O restante pode deixar as configurações default. Clique em *Deploy* e aguarde o fim do processo.  
Quando terminar, clique no botão *Boot* para ligar a máquina.

OBS: Se utilizar o [Linode Stack Script](http://github.com/alobato/rails-nginx-stack/raw/master/linode-stack-script.sh) no deploy (recomendado), pule os itens 2, 3, 4 e 5.


2. Acesse o servidor
--------------------
Ainda no painel de controle do Linode, clique no menu Network.  
Veja o ip do servidor (eth0) na caxa Network Settings.

No terminal acesse:

	ssh root@numero.ip

O sistema vai perguntar se você aceita o RSA key. Digite **yes**.  
Digite a senha do root que você definiu quando criou a distribuição linux.


3. Atualize o sistema
----------------------------------
Atualize o banco de dados de pacotes (etc/apt/sources.list) e a distribuição:

	apt-get install aptitude
	aptitude update
	aptitude -y full-upgrade


4. Crie um usuáro
------------------
Crie o usuário:

	adduser username

O sistema vai pedir uma senha e para as demais informações aperte **Enter**.
No final digite **Y** para confirmar.

Edite /etc/sudores:

	nano /etc/sudoers

E adicione no final do arquivo a linha abaixo:  
>username ALL=(ALL) ALL

Dê **control+x** - **Y** - **Enter**


5. Reinicie o servidor
----------------------
	shutdown -r now


6. Acesse o servidor com o usuário criado
------------------------------------------
Se usou stack, inicie a máquina, clicando em **Boot** no painel de controle.

	ssh username@numero.ip


7. Execute os comandos para rodar o scritpt:
--------------------------------------------
	sudo aptitude install wget -y
	wget http://github.com/alobato/rails-nginx-stack/raw/master/install.sh
	chmod +x install.sh
	sudo ./install.sh


8. Rode o gerador de chaves pública/privada
-------------------------------------------
	ssh-keygen

Digite Enter para aceitar o arquivo padrão. Deixe a senha em branco, confirmando em seguida.  
Pegue a chave publica:

	cat ~/.ssh/id_rsa.pub

e adicione no [GitHub](https://github.com/account#ssh_bucket)  


9. Configure o database.yml
---------------------------
Edite o arquivo, fornecendo informações do banco de dados de produção. Exemplo:

	production:
	    adapter: mysql
	    encoding: utf8
	    database: nome_do_projeto_production
	    username: root
	    password: senha
	    host: 127.0.0.1


9. Baixe o projeto do GitHub
----------------------------
Não esqueça de fazer:   

	sudo chown -R username /var/www

Faça o clone do repositório Git:

	cd /var/www
	git clone --depth 1 git@github.com:username/nome_do_projeto.git

Você pode pular os itens 9 e 10 se utilizar o plugin [Inploy](http://github.com/dcrec1/inploy):   


10. Configure a aplicação Rails
--------------------------------
Rode:

	cd /var/www/nome_do_projeto
	mkdir tmp
	rake db:create
	rake db:migrate


11. Configure o Nginx
---------------------
>`sudo nano /usr/local/nginx/conf/nginx.conf`

    server {
        listen 80;
        server_name www.dominio.com;
        root /var/www/nome_do_projeto/public;
        passenger_enabled on;
    }

>`sudo /etc/init.d/nginx restart`


12. Instale o Munin
-------------------
* http://library.linode.com/server-monitoring/munin/ubuntu-8.04-hardy
* http://library.linode.com/web-servers/apache/access-control/httpd-authentication
* http://blog.edseek.com/archives/2006/07/13/munin-alert-email-notification/
* http://articles.slicehost.com/2010/4/9/enabling-munin-node-plug-ins-on-ubuntu
* http://jetpackweb.com/blog/2009/09/29/munin-graphs-for-phusion-passenger-a-k-a-mod_rails/
* http://www.alfajango.com/blog/how-to-monitor-your-railspassenger-app-with-munin#configure-munin-for-passenger-stats


Referências
------------
* http://library.linode.com
* http://library.linode.com/using-linux/administration-basics
* http://github.com/benschwarz/passenger-stack
* http://github.com/crafterm/sprinkle
* http://www.modrails.com/documentation/Users%20guide%20Nginx.html
* http://articles.slicehost.com/2010/4/30/ubuntu-lucid-setup-part-1
* http://articles.slicehost.com/2010/4/30/ubuntu-lucid-setup-part-2
* http://www.slideshare.net/mrprompt/alta-perfomance-de-aplicaes-php-com-nginx
* http://www.mensk.com/webmaster-toolbox/perfect-ubuntu-hardy-nginx-mysql5-php5-wordpress/
* http://wiki.nginx.org/NginxHttpCoreModule
* http://nginx.org/en/docs/http/request_processing.html
* http://github.com/jnstq/rails-nginx-passenger-ubuntu