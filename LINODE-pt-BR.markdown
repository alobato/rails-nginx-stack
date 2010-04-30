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
>`ssh root@numero.ip`

O sistema vai perguntar se você aceita o RSA key. Digite **yes**.  
Digite a senha do root que você definiu quando criou a distribuição linux.


3. Atualize o sistema
----------------------------------
Atualize o banco de dados de pacotes (etc/apt/sources.list) e a distribuição:

>`aptitude update`  
>`aptitude -y full-upgrade`


4. Crie um usuáro
------------------
Crie o usuário:  
>`adduser username`

O sistema vai pedir uma senha e para as demais informações aperte **Enter**.
No final digite **Y** para confirmar.

Edite /etc/sudores:  
>`nano /etc/sudoers`

E adicione no final do arquivo a linha abaixo:
>username ALL=(ALL) ALL

Dê **control+x** - **Y** - **Enter**


5. Reinicie o servidor
----------------------
>`sudo shutdown -r now`


6. Acesse o servidor com o usuário criado
------------------------------------------
>`ssh username@numero.ip`


7. Execute os comandos para rodar o scritpt:
-------------------
wget http://github.com/alobato/rails-nginx-stack/raw/master/install.sh
chmod +x install.sh
./install.sh senha-do-mysql


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
