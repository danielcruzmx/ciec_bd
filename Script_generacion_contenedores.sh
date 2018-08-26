# Generacion de contenedor mysql

sudo docker run --name ciec_mysql -v ciec_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=valeria1 -d mysql:5.7

# ciec_data es un volumen creado con docker, el siguiente comando muestra el directorio fisico del volumen

sudo docker volume help
sudo docker volume list
sudo docker volume inspect ciec_data

# Generacion del contenedor phpMyAdmin

sudo docker run --name ciec_admin -d --link ciec_mysql:db -p 8080:80 phpmyadmin/phpmyadmin

# 
