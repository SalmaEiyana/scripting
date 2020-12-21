# Funcion Usuario - Añade un usuario manualmente a ".ally" y ".local"
function Usuario(){
# Leer las variables para poder añadir un usuario
    $nombre=Read-Host "Introduce el nombre del usuario"
    $ap=Read-Host "Introduce el primer apellido del usuario"
    $ap2=Read-Host "Introduce el segundo apellido del usuario"
    $sesion=Read-Host "Introduce el nombre de inicio de sesion"
    $pass=Read-Host -Prompt "Introduce la contraseña del usuario" -AsSecureString
    $pass2=Read-Host -Prompt "Vuelve a introducir la contraseña del usuario" -AsSecureString
# Compara las contraseñas y comprueba que son iguales
    $pass="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)))"
    $pass2="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass2)))"
# Para evitar que continúe con el script hasta que coincidan las contraseñas
    while ($pass -ne $pass2){
        Write-Host "Las contraseñas no coinciden, introduce tu contraseña de nuevo"
        $pass=Read-Host -Prompt "Introduce la contraseña del usuario" -AsSecureString
        $pass2=Read-Host -Prompt "Vuelve a introducir la contraseña del usuario" -AsSecureString
        $pass="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)))"
        $pass2="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass2)))"
    }
    $grupo=Read-Host "Introduce el grupo del usuario"
# Definimos el fichero log en el que se registrarán los cambios
    $dirlog="C:\Users\yoda.ALDERAAN\Desktop\logusuarios.log"
    "#### COMIENZA LA INSERCION MANUAL DE USUARIO EN POWERSHELL" >> $dirlog
# Crear usuario y añadirlo al grupo
    try{
        New-ADUser -DisplayName:"$nombre $ap" -AccountPassword(ConvertTo-SecureString $pass -AsPlainText -Force) -GivenName:"$nombre" -Initials:$null -Name:"$nombre $ap" -Path:"OU=ALDERAAN,DC=$nom,DC=local" -SamAccountName:"$sesion" -Server:"ad.alderaan.local" -Surname:"$ap" -Type:"user" -UserPrincipalName:"$sesion@alderaan.local" -Enabled $True
        Add-ADGroupMember -Identity $grupo -Members $sesion
        Write-Host -ForegroundColor Green "El usuario $nombre $ap se ha creado correctamente"
        "CORRECTO: $fecha  ---  El usuario $nombre $ap se ha creado correctamente." >> $dirlog
    }
    catch{
        Write-Warning "No se ha podido crear el usuario"
        "ERROR: $fecha  ---  No se ha podido crear el usuario $nombre $ap. " >> $dirlog
    }
    "#### FINALIZA LA INSERCION MANUAL DE USUARIO EN POWERSHELL" >> $dirlog
# Conecta mediante SSH, pasando los parámetros que va a coger en bash
    ssh -t yoda@192.168.24.2 sudo bash /home/ALDERAAN/yoda/monouser.sh $nom $nombre $ap $ap2 $sesion $pass $grupo
# Copias el fichero log de bash a powershell
    Get-SCPFile -ComputerName "192.168.24.2" -Credential yoda -RemoteFile "/home/ALDERAAN/yoda/bashlog.log"  -LocalFile "bashlog.log"
# Escribes el contenido del log de bash en el log de powershell
    Get-Content "bashlog.log" >>  $dirlog
}

# Funcion CSV - Añade usuarios con un fichero csv
function Csv(){
# Lees el nombre del fichero csv que quieres importar, lo importas e indicas el fichero log
    $archivo=Read-Host "Dime el nombre del fichero CSV que deseas importar"
    $usuarios=Import-Csv -Path $archivo
    $dirlog="C:\Users\yoda.ALDERAAN\Desktop\logusuarios.log"
    $fecha=$(get-date)
# Miramos a ver si existe el archivo
    if (Test-Path $archivo){
        "#### EMPIEZA TRATAMIENTO DE CSV EN POWERSHELL #### " >> $dirlog
        Get-Content $archivo | ForEach-Object{
# Sacamos el contenido del fichero, asignando una variable a cada 
# item, que esta separado por comillas
            $numero=$_.split(";")[0]
            $nombre=$_.split(";")[1]
            $ap=$_.split(";")[2]
            $sesion=$_.split(";")[3]
            $pass=$_.split(";")[4]
            $grupo=$_.split(";")[5]
# Añadimos un usuario nuevo, y ese usuario lo añadimos al grupo
            try{
                New-ADUser -DisplayName:"$nombre $ap" -AccountPassword(ConvertTo-SecureString $pass -AsPlainText -Force) -GivenName:"$nombre" -Initials:$null -Name:"$nombre $ap" -Path:"OU=ALDERAAN,DC=$nom,DC=local" -SamAccountName:"$sesion" -Server:"ad.$nom.local" -Surname:"$ap" -Type:"user" -UserPrincipalName:"$sesion@alderaan.local" -Enabled $True
                Add-ADGroupMember -Identity $grupo -Members $sesion
                Write-Host -ForegroundColor Green "El usuario $nombre $ap se ha creado correctamente."
                "CORRECTO: $fecha  ---  El usuario $nombre $ap se ha creado correctamente." >> $dirlog
            }
            catch{
                Write-Warning "No se ha podido crear el usuario $nombre $ap."
                "ERROR: $fecha  ---  No se ha podido crear el usuario $nombre $ap. " >> $dirlog
            }
	    }
        "#### FINALIZA TRATAMIENTO DE CSV EN POWERSHELL #### " >> $dirlog
        "#### COMIENZA TRATAMIENTO DE CSV EN BASH #### " >> $dirlog
# Movemos el archivo log ($archivo) a bash, y nos conectamos por ssh
        Set-SCPFile -ComputerName "192.168.24.2" -Credential yoda -RemotePath "/home/ALDERAAN/yoda"  -LocalFile "$archivo"
        ssh -t yoda@192.168.24.2 sudo bash /home/ALDERAAN/yoda/usuarios1.sh $archivo $nom
# Copiamos el log de bash a powershell, y escribimos su contenido en el log de powershell para tener
# todo el log en un solo archivo
        Get-SCPFile -ComputerName "192.168.24.2" -Credential yoda -RemoteFile "/home/ALDERAAN/yoda/bashlog.log"  -LocalFile "bashlog.log"
        Get-Content "bashlog.log" >>  $dirlog
    }
}
# Funcion Ver - Visualiza el log de usuarios. Indicamos cual es el fichero y lo visualizamos
function Ver(){
    $dirlog="C:\Users\yoda.ALDERAAN\Desktop\logusuarios.log"
    Get-Content $dirlog
}
function Vaciar(){
# Funcion Vaciar - Indicamos el fichero log a vaciar, y sobreescribimos su contenido con "" para vaciarlo.
    $dirlog="C:\Users\yoda.ALDERAAN\Desktop\logusuarios.log"
    try{
        "" > $dirlog
        Write-Host -ForegroundColor Green "El fichero log se ha vaciado correctamente"
    }catch{
        Write-Warning "Se ha producido un error al intentar borrar el fichero."
    }
}
# El menu que nos sale tras introducir el nombre del dominio
function Menu() {
Clear-Host
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "     TAREAS DE ADMINISTRACION "
Write-Host "            $nom.ally"
Write-Host "            $nom.local "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "Selecciona una de las siguientes opciones..."
Write-Host "1. Introducir usuario"
Write-Host "2. Cargar usuarios desde CSV"
Write-Host "3. Ver fichero log"
Write-Host "4. Vaciar fichero log"
Write-Host "0. Exit"

# Funciones para las opciones que elijamos
$opcion = Read-Host "Introduce una opción [0 - 4] "
switch ($opcion){
        1{
            Usuario
            pause
            Menu
        }
        2{
            Csv
            pause
            Menu
        }
        3{
            Ver
            pause
            Menu
        }
        4{
            Vaciar
            pause
            Menu
        }
        0{
            exit
        }
        default{
            Write-Host -ForegroundColor Red "Error..." 
            Start-Sleep -s 2
        }
    }
}
# El inicio del menu, nos pide el dominio y tras introducirlo nos lleva al menu
while ($true) {
    $nom=Read-Host "Introduce el nombre del dominio"
    Menu
}