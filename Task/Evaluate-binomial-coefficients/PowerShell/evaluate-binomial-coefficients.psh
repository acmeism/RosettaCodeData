function choose($n,$k) {
    if($k -le $n -and 0 -le $k) {
        $numerator = $denominator = 1
        0..($k-1) | foreach{
            $numerator *= ($n-$_)
            $denominator *= ($_ + 1)
        }
        $numerator/$denominator
    } else {
        "$k is greater than $n or lower than 0"
    }
}
choose 5 3
choose 2 1
choose 10 10
choose 10 2
choose 10 8
