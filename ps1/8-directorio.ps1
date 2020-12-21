$ruta = Read-Host 'Dime la ruta del archivo que quieres verificar si existe'
$exist=Test-Path $ruta
$existdir=Test-Path $ruta -PathType Leaf
if ($exist -like "False"){
    Write "Ese archivo no existe"
} elseif ($exist -like "True"){
            if ($existdir -like "False"){
                Write "--Eso es una carpeta"
                Write "--Estos son los archivos que hay dentro de esa carpeta:"
                Get-ChildItem -Force $ruta | Select-Object Name,length | Sort-Object length #-Descending
            } elseif ($existdir -like "True"){
                Write "--ERROR! eso es un archivo, no una carpeta"
            }
}