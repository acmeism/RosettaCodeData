# Anti-primes
[uint16]$counter = 0
[uint16]$max = 0
[uint16]$num = 1
$out = ''
while ($true) {
  $cnt = 0
  $dv = 1
  do {
    if ($num % $dv -eq 0) {
      $cnt++
    }
    $dv++
  } while ($dv -le $num)
  if ($cnt -gt $max) {
    $out += "$num "
    $max = $cnt
    $counter++
    if ($counter -ge 20) {
      break
    }
  }
  $num++
}
Write-Output $out
