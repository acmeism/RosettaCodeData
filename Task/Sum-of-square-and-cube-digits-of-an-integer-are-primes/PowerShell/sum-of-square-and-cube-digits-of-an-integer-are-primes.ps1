# Sum of square and cube digits of an integer are primes

function Is-Prime {
  [OutputType([bool])]
  param([uint32]$Num)

  if ($Num -lt 2) {
    return $false
  }
  if ($Num -eq 2) {
    return $true
  }
  if ($Num % 2 -eq 0) {
    return $false
  }
  [uint32]$i = 3
  while ($i * $i -le $Num) {
    if ($Num % $i -eq 0) {
      return $false
    }
    $i += 2
  }
  return $true
}

function Sum-Digits {
  [OutputType([uint32])]
  param([uint32]$Num)

  [uint32]$sum = 0
  [uint32]$numTmp = $Num
  while ($numTmp -ne 0) {
    $sum += $numTmp % 10
    $numTmp = [math]::Floor($numTmp / 10)
  }
  return $sum
}

[string]$out = @()
foreach ($n in 0..99) {
  if ((Is-Prime(Sum-Digits($n *$n))) -and (Is-Prime(Sum-Digits($n *$n *$n)))) {
    $out += "$n "
  }
}
Write-Output $out
