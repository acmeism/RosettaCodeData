$e0 = 0
$e = 2
$n = 0
$fact = 1
while([Math]::abs($e-$e0) -gt 1E-15){
   $e0 = $e
   $n += 1
   $fact *= 2*$n*(2*$n+1)
   $e += (2*$n+2)/$fact
}

Write-Host "Computed e = $e"
Write-Host "    Real e = $([Math]::Exp(1))"
Write-Host "     Error = $([Math]::Exp(1) - $e)"
Write-Host "Number of iterations = $n"
