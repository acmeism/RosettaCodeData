function isPrime ($n) {
    if ($n -le 1) {$false}
    elseif (($n -eq 2) -or ($n -eq 3)) {$true}
    else{
        $m = [Math]::Floor([Math]::Sqrt($n))
        (@(2..$m | where {($_ -lt $n)  -and ($n % $_ -eq 0) }).Count -eq 0)
    }
}
function semiprime ($n) {
    if($n -gt 3) {
        $lim = [Math]::Floor($n/2)+1
        $i = 2
        while(($i -lt $lim) -and ($n%$i -ne 0)){ $i += 1}
        if($i -eq $lim){@()}
        elseif(-not (isPrime ($n/$i))){@()}
        else{@($i,($n/$i))}
    } else {@()}
}
$OFS = " x "
"1679: $(semiprime 1679)"
"87: $(semiprime   87)"
"25: $(semiprime 25)"
"12: $(semiprime   12)"
"6: $(semiprime   6)"
$OFS = " "
"semiprime from 1 to 100: $(1..100 | where {semiprime $_})"
