# Indicamos ruta del archivo
$filename= "servers.txt"
$fecha=$(get-date)
Get-Content $filename | ForEach-Object {
    $ips=$_.split(":")[1]
    $nom=$_.split(":")[0]
    if(!(Test-Connection $ips -BufferSize 16 -Count 1 -quiet)){
        "$nom : No tiene conexion. $fecha" >> conexiones.log
    }else {
        "$nom : Tiene conexion. $fecha" >> conexiones.log
    } 
}
