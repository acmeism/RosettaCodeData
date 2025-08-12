# AKS test for primes

$script:PasTriMax = 61 # for long type of Pascal triangle numbers

function Pascal-Triangle {
  # Calculate the n'th line 0.. middle
  param(
    [int]$N
  )

  $pasTri = [long[]]::new([math]::Ceiling(($N + 2) / 2))
  $pasTri[0] = 1
  [int]$j = 1
  while ($j -le $N) {
    $j++
    [int]$k = [math]::Floor($j / 2)
    $pasTri[$k] = $pasTri[$k - 1]
    for (; $k -ge 1; $k--) {
      $pasTri[$k] += $pasTri[$k - 1]
    }
  }
  # Now: $j -eq ($N + 1), so $k -eq [math]::Floor(($N + 1) / 2)
  return $pasTri
}

function Expand-Poly {
  param ([int]$N)

  if ($N -gt $script:PasTriMax) {
    throw "$N is out of range"
  }
  switch($N) {
    0 {Write-Output "(x-1)^0 = 1"}
    1 {Write-Output "(x-1)^1 = x-1"}
    default {
      $VZ = @('+', '-')
      $pasTri = Pascal-Triangle($N)
      [string]$outTri = @()
      $outTri += "(x-1)^$N = x^$N"
      [bool]$bVz = $true
      [int]$nDiv2 = [math]::Floor($N / 2)
      for ([int]$j = $N - 1; $j -gt $nDiv2; $j--) {
        $outTri += "$($VZ[$bVz]) $($pasTri[$N - $j])*x^$j"
        $bVz = -not $bVz
      }
      for ([int]$j = $nDiv2; $j -gt 1; $j--) {
        $outTri += "$($VZ[$bVz]) $($pasTri[$j])*x^$j"
        $bVz = -not $bVz
      }
      $outTri += "$($VZ[$bVz]) $($pasTri[1])*x"
      $bVz = -not $bVz
      $outTri += "$($VZ[$bVz]) $($pasTri[0])"
      Write-Output $outTri
    }
  }
}

function Is-Prime {
  param([int]$N)

  if ($N -gt $script:PasTriMax) {
    throw "$N is out of range"
  }
  $pasTri = Pascal-Triangle($N)
  [bool]$res = $true
  [int]$i = [math]::Floor($N / 2)
  while ($res -and ($i -gt 1)) {
    $res = $res -and ($pasTri[$i] % $N -eq 0)
    $i--
  }
  return $res
}

# Test program
foreach ($n in 0..9) {
  Expand-Poly($n)
}
[string]$primes = @()
foreach ($n in 2..$script:PasTriMax) {
  if (Is-Prime($n)) {
    $primes += "{0,3}" -f $n
  }
}
Write-Output $primes
