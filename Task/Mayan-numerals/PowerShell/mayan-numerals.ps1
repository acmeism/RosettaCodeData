# Mayan numerals

$script:Ls = "    ", " .  ", " .. ", "... ", "....", "----"
$inputNum = Read-Host "Number"
$m = $inputNum.Length - 1
$d = [int[]]::new($m + 1)
foreach ($i in 0..$m) {
  $d[$i] = [byte]$inputNum[$i] - [byte][char]'0'
}

foreach ($j in $m..1) {
  foreach ($i in 0..($j - 1)) {
    $d[$i + 1] += 10 * ($d[$i] % 2)
    $d[$i] = [math]::Floor($d[$i] / 2)
  }
}
$s = 0
while (($d[$s] -eq 0) -and ($s -lt $m)) {
  $s++
}
[string]$row = @()
foreach ($i in $s..$m) {
  $row += "+----"
}
$row += "+"
Write-Output $row
foreach ($k in 3..0) {
  [string]$row = @()
  foreach ($i in $s..$m) {
    if (($d[$i] -eq 0) -and ($k -eq 0)) {
      $row += "| @  "
    } else {
      $n = $d[$i] - 5 * $k
      if ($n -gt 5) {
        $n = 5
      } elseif ($n -lt 0) {
        $n = 0
      }
      $row += "|$($script:Ls[$n])"
    }
  }
  $row += "|"
  Write-Output $row
}
[string]$row = @()
foreach ($i in $s..$m) {
  $row += "+----"
}
$row += "+"
Write-Output $row
