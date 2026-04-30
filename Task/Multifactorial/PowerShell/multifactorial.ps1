# Multifactorial
function Get-Multifactorial {
  param(
    [uint32]$N,
    [uint32]$Degree
  )
  if ($N -lt 2) {
    return 1
  } else {
    [uint64]$result = $N
    for ($i = $N - $Degree; $i -ge 2; $i -= $Degree) {
      $result *= $i
    }
    return $result
  }
}

foreach ($degree in 1..5) {
  $out = "Degree $degree =>"
  foreach ($n in 1..10) {
    $out += " $(Get-Multifactorial $n $degree)"
  }
  Write-Output $out
}
