# Chebyshev coefficients
$a = 0
$b = 1
$n = 10
$cheby = [double[]]::new($n)
$coef = [double[]]::new($n)
$piDivN = [Math]::Pi / $n
$bPlADiv2 = ($b + $a) / 2
$bMiADiv2 = ($b - $a) / 2
$lastN = $n - 1
foreach ($i in 0..$lastN) {
  $coef[$i] = [Math]::Cos([Math]::Cos($piDivN * ($i + .5)) * $bMiADiv2 + $bPlADiv2)
}
foreach ($i in 0..$lastN) {
  $w = 0
  foreach ($j in 0..$lastN) {
    $w += $coef[$j] * [Math]::Cos($piDivN * $i * ($j + .5))
  }
  $cheby[$i] = $w * 2 / $n
  Write-Output "$($i): $($cheby[$i])"
}
