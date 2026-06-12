# Idoneal numbers

function Is-Idoneal {
  param([uint32]$N)
  foreach ($a in 1..$N) {
    foreach ($b in ($a + 1)..$N) {
      $ab = $a * $b
      $s = $a + $b
      if ($ab + $s -gt $N) {
        break
      } else {
        foreach ($c in ($b + 1)..$N) {
          $t = $ab + $c * $s
          if ($t -eq $N) {
            return $false
          }
          if ($t -gt $N) {
            break
          }
        }
      }
    }
  }
  return $true
}

$n = 1
$c = 0
$out = ''
do {
  if (Is-Idoneal $n) {
    $out += ('{0,5}' -f $n)
    $c++
    if ($c % 13 -eq 0) {
      Write-Output $out
      $out = ''
    }
  }
  $n++
} while ($c -lt 65)
