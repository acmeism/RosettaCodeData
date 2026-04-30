# Bell numbers
[uint32]$script:MaxN = 14
$a = [uint32[]]::new($script:MaxN)
foreach ($i in 0..($script:MaxN - 1)) {
  $a[$i] = 0
}
[uint32]$n = 0
$a[0] = 1
[string]$row = "B({0, 2}) = {1,9}" -f $n, $a[0]
Write-Output $row
while ($n -lt $script:MaxN) {
  $a[$n] = $a[0]
  foreach ($j in $n..1) {
    $a[$j - 1] += $a[$j]
  }
  $n++
  [string]$row = "B({0, 2}) = {1,9}" -f $n, $a[0]
  Write-Output $row
}
