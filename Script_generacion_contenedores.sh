# Generacion de contenedor mysql

sudo docker run --name ciec_mysql -v ciec_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=XXXXXX -d mysql:5.7

# ciec_data es un volumen creado con docker, los siguientes comandos muestran informacion del volumen

sudo docker volume help
sudo docker volume create ciec_data
sudo docker volume list
sudo docker volume inspect ciec_data

# Generacion del contenedor phpMyAdmin

sudo docker run --name ciec_admin -d --link ciec_mysql:db -p 8080:80 phpmyadmin/phpmyadmin

# Respaldo de la base de datos con el contenedor en ejecucion

sudo docker exec ciec_mysql /usr/bin/mysqldump --routines --add-drop-database --databases ciecv31 -u root --password=XXXXXX > backup_26_ago_2018_bis.sql

# Recupercion del respaldo en otro contenedor en ejecucion

cat backup_26_ago_2018_bis.sql | sudo docker exec -i ciec_mysql_n /usr/bin/mysql -u root --password=XXXXXX

# Creacion del contenedor de la aplicacpn Python, Django

sudo docker run -dit -v /home/danielcruzmx/ciecv31:/home --name ciec_app --link ciec_mysql:db -p 8000:8000 moxel/python3

# Ejecucion de una sesion dentro del contenedor de aplicacion

sudo docker exec -it ciec_app bash

# Si es primera vez, actualizar pip e instalar requerimientos de python3

pip install -r requirements.txt

# Si se requiere actualizar base de datos

python3 manage.py makemigrations
python3 manage.py migrate

# Si lo anterior da problemas, entonces dar reset de la siguiente manera

1) Limpiar la tabla django_migrations desde phpMyAdmin: delete from django_migrations
2) Por cada App, borrar el folder migrations: rm -rf app/migrations/
3) Reset de migrations en el "built-in": python3 manage.py migrate --fake
4) Por cada App: python3 manage.py makemigrations <app>
5) Finalmente: python3 manage.py migrate --fake-initial

# Ejecucion de la aplicacion en modo de desarrollo con runserver

python3 manage.py runserver 0.0.0.0:8000

# Ejecucion de la aplicacion en modo produccion

pip install supervisor
supervisord -c /home/conf/supervisord.conf

# Para parar el proceso

pkil -QUIT supervisord

# Cliente angular para explotar servicios de Django

sudo docker run -dti --rm --name clienteangular -v /home/danielcruzmx/appsAngular:/app -p 4200:4200 -p 49153:49153 -p 9876:9876 -p 49152:49152 pivotalpa/angular-cli

# Ejecucion de una sesion dentro del contenedor del cliente angular

sudo docker exec -it clienteangular sh

# Ejecucion de la aplicacion, si es por pimera vez ejecutar

npm install # dentro del directorio de la aplicacion

ng serve -H 0.0.0.0  # Si ya se instalaron los modulos iniciales
