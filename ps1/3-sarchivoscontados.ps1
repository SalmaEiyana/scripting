$nom=Read-Host "Dime el nombre del archivo que quieres crear"
$cant=Read-Host "Dime cuantos archivos quieres crear"
for($i=1;$i -le $cant;$i++){
    Write-Output "Este es el archivo numero $i" > $HOME\$i$nom.txt 
}