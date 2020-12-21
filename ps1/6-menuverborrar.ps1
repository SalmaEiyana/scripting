function Borrar(){
    try{
        Remove-Item -Path $nom -ErrorAction Stop
        Write-Host "Fichero borrado con exito"
    }catch{
        Write-Warning "Se ha producido un error al intentar borrar el fichero."
    }
}
function Ver(){
    Get-Content $nom
}
function Menu() {
Clear-Host
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host " MENU - LÍNEA DE COMANDOS "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "Selecciona una de las siguientes opciones..."
Write-Host "1. Borrar el fichero"
Write-Host "2. Ver contenido"
Write-Host "0. Exit"

$opcion = Read-Host "Introduce una opción [1 - 2] "
switch ($opcion){
        1{
            Borrar
            pause
            exit
        }
        2{
            Ver
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
    $nom=Read-Host "Dime el nombre del fichero"
    Menu
}