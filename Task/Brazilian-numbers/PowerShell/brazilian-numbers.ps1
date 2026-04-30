# Brazilian numbers

function Same-Digits($N, $B) {
  # Result: $true if $N has same digits in the base $B, $false otherwise
  $nl = $N
  $f = $nl % $B
  $nl = [math]::Floor($nl / $B)
  while ($nl -gt 0) {
    if (($nl % $B) -ne $f) {
       return $false
    }
    $nl = [math]::Floor($nl / $B)
  }
  return $true
}

function Is-Brazilian($N) {
  if ($N -lt 7) {
    return $false
  } elseif (($N % 2 -eq 0) -and ($N -ge 8)) {
    return $true
  } else {
    foreach ($b in 2..($N - 2)) {
      if (Same-Digits $N $b) {
        return $true
      }
    }
    return $false
  }
}

function Is-Prime($N) {
  if ($N -lt 2) {
    return $false
  } elseif (($N % 2) -eq 0) {
    return ($N -eq 2)
  } elseif ($N % 3 -eq 0) {
    return ($N -eq 3)
  } else {
    $d = 5
    while ($d * $d -le $N) {
      if (($N % $d) -eq 0) {
        return $false
      } else {
        $d += 2
        if (($N % $d) -eq 0) {
          return $false
        } else {
          $d += 4
        }
      }
    } # while
    return $true
  }
}

Write-Output "First 20 Brazilian numbers:"
$c = 0
$n = 7
[string]$row = @()
while ($c -lt 20) {
  if (Is-Brazilian $n) {
    $row += "$n "
    $c++
  }
  $n++
}
Write-Output $row
Write-Output ""
Write-Output "First 20 odd Brazilian numbers:"
$c = 0
$n = 7
[string]$row = @()
while ($c -lt 20) {
  if (Is-Brazilian $n) {
    $row += "$n "
    $c++
  }
  $n += 2
}
Write-Output $row
Write-Output ""
Write-Output "First 20 prime Brazilian numbers:"
$c = 0
$n = 7
[string]$row = @()
while ($c -lt 20) {
   if (Is-Brazilian $n) {
      $row += "$n "
      $c++
   }
   do {
      $n += 2
   } while (-not (Is-Prime $n))
}
Write-Output $row
