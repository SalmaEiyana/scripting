function Usuario(){
    $nombre=Read-Host "Introduce el nombre del usuario"
    $ap=Read-Host "Introduce el apellido del usuario"
    $sesion=Read-Host "Introduce el nombre de inicio de sesion"
    $pass=Read-Host -Prompt "Introduce la contraseña del usuario" -AsSecureString
    $pass2=Read-Host -Prompt "Vuelve a introducir la contraseña del usuario" -AsSecureString
    $pass="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)))"
    $pass2="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass2)))"
    while ($pass -ne $pass2){
        Write-Host "Las contraseñas no coinciden, introduce tu contraseña de nuevo"
        $pass=Read-Host -Prompt "Introduce la contraseña del usuario" -AsSecureString
        $pass2=Read-Host -Prompt "Vuelve a introducir la contraseña del usuario" -AsSecureString
        $pass="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)))"
        $pass2="$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass2)))"
    } done
    $grupo=Read-Host "Introduce el grupo del usuario"
    try{
    New-ADUser -name $nombre -AccountPassword $pass -GivenName $nombre -Surname $ap -DisplayName $sesion
    Add-ADGroupMember -Identity $grupo -Members $nombre
    }catch{
        Write-Warning "No se ha podido crear el usuario"
    }
}

    #New-LocalUser -Name "$sesion" -Password "$password" -FullName "$nombre $ap"
    #Add-LocalGroupMember -Group "$grupo" -Member "$sesion"

function Csv(){
    Set-Location C:\Users\si2\Downloads
    $archivo=Read-Host "Dime el nombre del fichero CSV que deseas importar"
    $usuarios=Import-Csv -Path $archivo
    Get-Content $archivo | ForEach-Object{
        $numero=$_.split(";")[0]
        $nombre=$_.split(";")[1]
        $apellido=$_.split(";")[2]
        $login=$_.split(";")[3]
        $pass=$_.split(";")[4]
        # $passw=ConvertTo-SecureString $pass -AsPlainText -Force
        $grupo=$_.split(";")[5]
		Write-Host "$numero"
        Write-Host "$nombre"
        Write-Host "$apellido"
        Write-Host "$login"
        Write-Host "$pass"
        Write-Host "$grupo"
	}
}
function Ver(){
    
}
function Vaciar(){
    
}
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

$opcion = Read-Host "Introduce una opción [0 - 4] "
switch ($opcion){
        1{
            Usuario
            pause
            exit
        }
        2{
            Csv
            pause
            exit
        }
        3{
            Ver
            pause
            exit
        }
        4{
            Vaciar
            pause
            exit
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
while ($true) {
    $nom=Read-Host "Introduce el nombre del dominio"
    Menu
}