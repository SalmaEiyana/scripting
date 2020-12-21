#### Funciones

## Opción uno	
function Suma(){
    [int]$num1 = Read-Host "Indica el primer numero para hacer la suma"
    [int]$num2 = Read-Host "Indica el segundo numero"
    Write-Host "El resultado de la suma es: "
    $total=$num1+$num2;
    Write-Host $total
}
## Opción dos
function Resta(){
    [int]$num1 = Read-Host "Indica el primer numero para hacer la resta"
    [int]$num2 = Read-Host "Indica el segundo numero"
    Write-Host "El resultado de la resta es: "
    $total = $num1 - $num2;
    Write-Host $num1 "-" $num2 "=" $total
}
# Opción tres	
function Multiplicacion(){
    [int]$num1 = Read-Host "Indica el primer numero para hacer la multiplicacion"
    [int]$num2 = Read-Host "Indica el segundo numero"
    Write-Host "El resultado de la multiplicacion es: "
    $total = $num1 * $num2;
    Write-Host $num1 "x" $num2 "=" $total
}
# Opción cuatro	
function Division(){
    [int]$num1 = Read-Host "Indica el primer numero para hacer la division"
    [int]$num2 = Read-Host "Indica el segundo numero"
    if($num2 -eq 0) {
    echo "No puede realizarse una division por 0"
    }else{
    Write-Host "El resultado de la division es: "
    $total = $num1 / $num2;
    Write-Host $num1 "/" $num2 "=" $total
    }
}
#Menú	
function Menu() {
Clear-Host
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host " MENU - LÍNEA DE COMANDOS "
Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
Write-Host "Selecciona una de las siguientes opciones..."
Write-Host "1. Sumar"
Write-Host "2. Restar"
Write-Host "3. Multiplicar"
Write-Host "4. Dividir"
Write-Host "0. Exit"

$opcion = Read-Host "Introduce una opción [0 - 4] "
switch ($opcion){
        1{
            Suma
            pause
        }
        2{
            Resta
            pause
        }
        3{
            Multiplicacion
            pause
        }
        4{
            Division
            pause
        }
        0{
            Exit
        }
        default{
            Write-Host -ForegroundColor Red "Error..." 
            Start-Sleep -s 2
        }
    }
}
# Bucle principal	
while ($true) {
    Menu
}