function isPrime ($n) {
    if ($n -eq 1) {$false}
    elseif ($n -eq 2) {$true}
    elseif ($n -eq 3) {$true}
    else{
        $m = [Math]::Floor([Math]::Sqrt($n))
        (@(2..$m | where {($_ -lt $n)  -and ($n % $_ -eq 0) }).Count -eq 0)
    }
}
1..15 | foreach{"isPrime $_ : $(isPrime $_)"}
