# Moebius function

function Moebius([int]$N) {
  [int]$m = 1
  if ($N -ne 1) {
    [int]$f = 2
    do {
      if ($N % ($f * $f) -eq 0) {
        $m = 0
      } else {
        if ($N % $f -eq 0) {
          $m = -$m;
          $N = [math]::Floor($N / $f)
        }
        $f += 1
      }
    } while (($f -le $N) -and ($m -ne 0))
  }
  return $m
}

foreach ($t in 0..9) {
  [string]$row = @()
  foreach ($u in 1..10) {
    $row += "{0,2}  " -f $(Moebius(10 * $t + $u))
  }
  Write-Output $row
}
