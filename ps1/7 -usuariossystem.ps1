# Indicamos ruta del archivo
$alumnos= "C:\Users\si2\alumnos.txt"
foreach ($alumno in Get-Content $alumnos) {
    try{
        Get-LocalUser -Name $alumno -ErrorAction Stop | Out-Null
    }
    catch
    {
        Write-Host "$alumno no existe en el sistema"
    }
}
