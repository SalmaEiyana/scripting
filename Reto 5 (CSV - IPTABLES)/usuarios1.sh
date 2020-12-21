#!/bin/bash
# Recogemos las variables del csv y el nombre del dominio
# que nos pasa powershell
csv=$1
dom=$2
dominio="dc=$dom,dc=ally"
# Indicamos el ldif para crear los usuarios y para registrar los usuarios en sus
# correspondientes grupos
archivo="usuarioscsv.ldif"
cambios="cambios.ldif"
ou="ALDERAAN"
# Miramos a ver si existe el csv
if test -f "$csv"
then
# Añadimos una linea para que funcione bien el ldif
	echo "" > $archivo
# Cogemos el ultimo uid y lo asignamos a una variable
	uid=`getent passwd | cut -d ":" -f3 | sort -n | tail -1`
 	while IFS= read -r linea
        do
	## USUARIOS
# Recorremos el csv y guardamos la informacion en las variables
	        nombre=`echo $linea | cut -d ";" -f2`
	        ap=`echo $linea | cut -d ";" -f3`
	        sesion=`echo $linea | cut -d ";" -f4`
	        pass=`echo $linea | cut -d ";" -f5`
	        grupo=`echo $linea | cut -d ";" -f6`
		echo "dn: uid=$sesion,ou=$ou,$dominio" >> $archivo
		echo "objectClass: posixAccount" >> $archivo
		echo "objectClass: shadowAccount" >> $archivo
		echo "objectClass: inetOrgPerson" >> $archivo
		echo "cn: $nombre" >> $archivo
		echo "uid: $sesion" >> $archivo
		echo "sn: $ap" >> $archivo
		uid=$((uid+1))
		echo "uidNumber: $uid" >> $archivo
		gid=`ldapsearch -xLLL -b cn=$grupo,ou=$ou,$dominio gidNumber | grep "gidNumber" | cut -d ":" -f2`
		echo "gidNumber: $gid" >> $archivo
		echo "homeDirectory: /home/ALDERAAN/$sesion" >> $archivo
		echo "loginShell: /bin/bash" >> $archivo
		echo "gecos: $sesion" >> $archivo
		password=`sudo slappasswd -s $pass`
		echo "userPassword: $password" >> $archivo
		echo "" >> $archivo
	## CAMBIOS
		echo "dn: cn=$grupo,ou=ALDERAAN,$dominio" >> $cambios
		echo "changetype: modify" >> $cambios
		echo "add: memberUid" >> $cambios
		echo "memberuid: $sesion" >> $cambios
		echo "" >> $cambios
	done < $csv
	echo "" >> bashlog.log
	ldapadd -x -D cn=admin,$dominio -W -f $archivo >> bashlog.log
	ldapmodify -x -D cn=admin,$dominio -W -f $cambios >> bashlog.log
	echo "----- FINALIZA TRATAMIENTO DE CSV EN BASH ------" >> bashlog.log
else
        echo "El fichero no existe"
fi
