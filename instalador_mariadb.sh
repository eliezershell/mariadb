#!/bin/bash

sudo apt update
if [ $? -gt 0 ]; then
        echo "Erro ao atualizar pacotes do repositório APT!"; exit 0
fi

sudo apt install mariadb-server -y
if [ $? -gt 0 ]; then
        echo "Erro ao instalar MariaDB!"; exit 0
fi

echo "---------------------------------Verificando MariaDB--------------------------------"
service mysql status
echo "------------------------------------------------------------------------------------"

echo "----------------------------------Criando Database----------------------------------"
read -p "Nome de usuário: " usuario
read -p "Senha de usuário: " senha
read -p "Nome do banco de dados: " banco

sudo mysql -u root <<MYSQL_SCRIPT
CREATE USER '$usuario'@'%' IDENTIFIED BY '$senha';
CREATE DATABASE $banco;
GRANT ALL PRIVILEGES ON $banco.* TO '$usuario'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
if [ $? -gt 0 ]; then
        echo "Erro ao criar Database!"; exit 0
fi

sudo sed -i 's/^bind-address/# bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf
if [ $? -gt 0 ]; then
        echo "Erro ao alterar o arquivo 50-server.cnf!"; exit 0
fi

sudo systemctl restart mariadb

echo "------------------------------Instalação concluída com sucesso!------------------------------"
echo "----------------------Script by: Eliezer Ribeiro | linkedin.com/in/elinux--------------------"
exit 0
