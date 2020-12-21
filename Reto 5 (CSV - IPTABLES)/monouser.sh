#!/bin/bash
# Cogemos las variables que hemos indicado en powershell
dom=$1
nombre=$2
apellido1=$3
apellido2=$4
# Creamos la variable apellidos que contendra ambos apellidos
apellidos="$apellido1 $apellido2"
sesion=$5
password=$6
grupo=$7
# Indicamos el dominio
dominio="dc=$dom,dc=ally"
# Indicamos la OU
ou="ALDERAAN"
# Asignamos a una variable el ultimo UIDNumber asignado a un usuario
uid=`getent passwd | cut -d ":" -f3 | sort -n | tail -1`
# Asignamos a unas variables los archivos ldif que vamos a usar para añadir usuarios y para añadirlos a un grupo
archivo="monousuario.ldif"
grupoarchivo="grupouser.ldif"
## U S U A R I O ##
# Escribimos los parametros con la estructura de un archivo ldif para que se pueda crear el usuario
echo "dn: uid=$sesion,ou=$ou,$dominio" >> $archivo
echo "objectClass: posixAccount" >> $archivo
echo "objectClass: shadowAccount" >> $archivo
echo "objectClass: inetOrgPerson" >> $archivo
echo "cn: $nombre" >> $archivo
echo "uid: $sesion" >> $archivo
echo "sn: $apellidos" >> $archivo
# Sumamos uno a la uid para que no haya UIDNumber repetidas
uid=$((uid+1))
echo "uidNumber: $uid" >> $archivo
# Buscamos el gidNumber del grupo al que queremos asignar al usuario
gid=`ldapsearch -xLLL -b cn=$grupo,ou=$ou,$dominio gidNumber | grep "gidNumber" | cut -d ":" -f2`
echo "gidNumber: $gid" >> $archivo
echo "homeDirectory: /home/ALDERAAN/$sesion" >> $archivo
echo "loginShell: /bin/bash" >> $archivo
echo "gecos: $sesion" >> $archivo
# Encriptamos la password
pass=`sudo slappasswd -s $password`
echo "userPassword: $pass" >> $archivo
# Añadimos una linea para que no de problemas LDIF al crear usuarios,
# ya que es necesaria una separacion de una linea por cada DN.
echo "" >> $archivo
## G R U P O ##
# Añadimos el usuario al grupo
echo "dn: cn=$grupo,ou=$ou,$dominio" >> $grupoarchivo
echo "changetype: modify" >> $grupoarchivo
echo "add: memberUid" >> $grupoarchivo
echo "memberUid: $sesion" >> $grupoarchivo
echo "" >> $grupoarchivo
## L O G ##
# Registramos los cambios en el fichero log
echo "----- COMIENZA INSERCION DE USUARIO EN BASH -----" >> bashlog.log
ldapadd -x -D cn=admin,$dominio -W -f $archivo >> bashlog.log
ldapmodify -x -D cn=admin,$dominio -W -f $grupoarchivo >> bashlog.log
echo "----- FINALIZA INSERCION DE USUARIO EN BASH -----" >> bashlog.log
