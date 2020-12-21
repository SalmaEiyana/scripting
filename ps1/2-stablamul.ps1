[int]$num=Read-Host "Dime un numero"
Write-Host "La tabla de multiplicar es: "
for ($i = 1; $i -le 10; $i++) {
    $total = $i * $num;
    Write-Host $num "x" $i "=" $total
}