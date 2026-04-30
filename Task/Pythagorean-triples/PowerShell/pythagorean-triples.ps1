function triples($p) {
    if($p -gt 4) {
        # ai + bi + ci = pi <= p
        # ai < bi < ci --> 3ai < pi <= p and ai + 2bi < pi <= p
        $pa = [Math]::Floor($p/3)
        1..$pa | foreach {
            $ai = $_
            $pb = [Math]::Floor(($p-$ai)/2)
            ($ai+1)..$pb | foreach {
                $bi = $_
                $pc = $p-$ai-$bi
                ($bi+1)..$pc | where {
                    $ci = $_
                    $pi = $ai + $bi + $ci
                    $ci*$ci -eq $ai*$ai + $bi*$bi
                 } |
                foreach {
                    [pscustomobject]@{
                        a = "$ai"
                        b = "$bi"
                        c = "$ci"
                        p = "$pi"
                    }
                }
            }
        }
    }
    else {
        Write-Error "$p is not greater than 4"
    }
}
function gcd ($a, $b)  {
    function pgcd ($n, $m)  {
        if($n -le $m) {
            if($n -eq 0) {$m}
            else{pgcd $n ($m%$n)}
        }
        else {pgcd $m $n}
    }
    $n = [Math]::Abs($a)
    $m = [Math]::Abs($b)
    (pgcd $n $m)
}
$triples = (triples 100)

$coprime = $triples |
where {((gcd $_.a $_.b) -eq 1) -and ((gcd $_.a $_.c) -eq 1) -and  ((gcd $_.b $_.c) -eq 1)}

"There are $(($triples).Count) Pythagorean triples with perimeter no larger than 100
 and $(($coprime).Count) of them are coprime."
