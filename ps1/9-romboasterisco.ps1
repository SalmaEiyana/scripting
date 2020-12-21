$num=Read-Host "Dame un numero entre 5 y 9"
Write-Host $num
if (($num -ge 5) -and ($num -le 9)){

    for ($i=1; $i -le $num; $i++){
       for ($s=$num;$s -ge $i;$s=$s-1){
           Write-Host -NoNewline " "
       }
       for ($j=1; $j -le $i; $j=$j+1){
           Write-Host -NoNewline "* "
       }
       Write-Host ""
   }
    for ($i=$num-1; $i -ge 1; $i=$i-1){
        for ($s=$i; $s -le $num; $s=$s+1){
            Write-Host -NoNewline " "
        }
        for ($j=1; $j -le $i; $j=$j+1){
            Write-Host -NoNewline "* "
        }
        Write-Host ""
    }
}else{
    Write-Host "El valor tiene que estar entre 5 y 9"
}