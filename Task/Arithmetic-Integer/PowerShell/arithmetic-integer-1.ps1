$a = [int] (Read-Host First Number)
$b = [int] (Read-Host Second Number)

Write-Host "Sum:                              $($a + $b)"
Write-Host "Difference:                       $($a - $b)"
Write-Host "Product:                          $($a * $b)"
Write-Host "Quotient:                         $($a / $b)"
Write-Host "Quotient, round to even:          $([Math]::Round($a / $b))"
Write-Host "Remainder, sign follows first:    $($a % $b)"
