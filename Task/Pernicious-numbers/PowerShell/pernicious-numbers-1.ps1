function pop-count($n) {
    (([Convert]::ToString($n, 2)).toCharArray() | where {$_ -eq '1'}).count
}

function isPrime ($n) {
    if ($n -eq 1) {$false}
    elseif ($n -eq 2) {$true}
    elseif ($n -eq 3) {$true}
    else{
        $m = [Math]::Floor([Math]::Sqrt($n))
        (@(2..$m | where {($_ -lt $n)  -and ($n % $_ -eq 0) }).Count -eq 0)
    }
}

$i = 0
$num = 1
$arr = while($i -lt 25) {
    if((isPrime (pop-count $num))) {
        $i++
        $num
    }
    $num++
}
"first 25 pernicious numbers"
"$arr"
""
"pernicious numbers between 888,888,877 and 888,888,888"
"$(888888877..888888888 | where{isprime(pop-count $_)})"
