#!/bin/bash
# Indicamos el fichero log
iptables="/var/log/iptables.log"
pause(){
        read -p "Presiona una tecla para continuar..." enterKey
}
if test -f "$iptables"
then
	Macorigen(){
		echo "Dime una direccion MAC"
        	read MAC
		macor="MACORIGEN_$MAC.log"
		echo "FILTRADO POR MAC" >> $macor
        	cat $iptables | grep -w "$MAC" | cut -d "=" -f4 | cut -d " " -f1 >> $macor
		echo "FIN DE FILTRADO POR MAC" >> $macor
		cat $macor
		pause
	}
	Iporigen(){
		echo "Dime una IP de origen"
		read ipor
		iporigen="IPORIGEN_$ipor.log"
		echo  "FILTRADO POR IP DE ORIGEN" >> $iporigen
		cat $iptables | grep -w SRC=$ipor >> $iporigen
		echo "FIN DE FILTRADO POR IP DE ORIGEN" >> $iporigen
		cat $iporigen
		pause
	}
	Ipdestino(){
		echo "Dime una IP de destino"
		read ipdes
		ipdestino="IPDESTINO_$ipdes.log"
		echo "FILTRADO POR IP DE DESTINO" >> $ipdestino
		cat $iptables | grep -w DST=$ipdes >> $ipdestino
		echo "FIN DE FILTRADO POR IP DE DESTINO" >> $ipdestino
		cat $ipdestino
		pause
	}
	Porigen(){
		echo "Dime un puerto de origen"
		read srport
		porigen="PUERTOORIGEN_$srport.log"
		echo "FILTRADO POR PUERTO DE ORIGEN" >> $porigen
		cat $iptables | grep -w SPT=$srport >> $porigen
		echo "FIN DE FILTRADO POR PUERTO DE ORIGEN" >> $porigen
		cat $porigen
		pause
	}
	Pdestino(){
		echo "Dime un puerto de destino"
		read destport
		pdestino="PUERTODESTINO_$destport.log"
		echo "FILTRADO POR PUERTO DE DESTINO" >> $pdestino
		cat $iptables | grep -w DPT=$destport >> $pdestino
		echo "FIN DE FILTRADO POR PUERTO DE DESTINO" >> $pdestino
		cat $pdestino
		pause
	}
	Otro(){
		pudp="PROTOCOLO_UDP.log"
		echo "FILTRADO POR PROTOCOLO UDP" >> $pudp
		cat $iptables | grep -w "PROTO=UDP" >> $pudp
		echo "FIN DE FILTRADO POR PROTOCOLO UPD" >> $pudp
		cat $pudp
		pause
	}
	Listado(){
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "   	LISTADO MAC ORIGEN   	    "
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        	cat $iptables | cut -d "=" -f4 | cut -d ":" -f1-6 | tail | sort | uniq
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "   	LISTADO MAC DESTINO   	    "
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        	cat $iptables | cut -d "=" -f4 | cut -d ":" -f7-12 | tail | sort | uniq
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "   	LISTADO IP DE ORIGEN	    "
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        	cat $iptables | cut -d "=" -f5 | cut -d " " -f1 | tail | sort | uniq
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "   	LISTADO IP DE DESTINO       "
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        	cat $iptables | cut -d "=" -f6 | cut -d " " -f1 | tail | sort | uniq
		pause
	}
	mostrarMenu(){
	        clear
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "   	LOG IPTABLES   	    "
	        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	        echo "1. Filtrar por MAC de origen"
	        echo "2. Filtrar por IP origen"
		echo "3. Filtrar por IP destino"
	        echo "4. Filtrar por puerto de origen"
	        echo "5. Filtrar por puerto de destino"
	        echo "6. Otro filtro (PROTO UDP)"
		echo "7. Listado de MAC e IPs"
		echo "0. Salir"
	}
	leerOpcion(){
	        #Creo variable local
	        local opcion
	        #Leo la opcion y la guardo en la variable
	        read -p "Introduce una opcion [0-7]: " opcion
	        case $opcion in
	                1)Macorigen;; # Filtrado por MAC de origen
	                2)Iporigen;; # Filtrado por IP de origen
	                3)Ipdestino;; # Filtrado por IP de destino
	                4)Porigen;; # Filtrado por puerto de origen
	                5)Pdestino;; # Filtrado por puerto de destino
	                6)Otro;; # Otro filtro
	                7)Listado;; # Listado de MAC e IPs
	                0)exit 0;; # Salir del Script
        	        *)echo "Error: No se ha introducido un valor válido" && sleep 2 # Con cualquier otro numero ERROR
        	esac
	}
	while true
	do
        	mostrarMenu #Muestro el menu
        	leerOpcion  #Leo la opcion
	done
else
	echo "El fichero log de IPTables no existe"
fi
