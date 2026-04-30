# Periodic table

[int[]]$script:A = 1, 2, 5, 13, 57, 72, 89, 104
[int[]]$script:B = -1, 15, 25, 35, 72, 21, 58, 7

function Show-Row-And-Column([int]$ANum) {
  [uint32]$i = 7
  while ($script:A[$i] -gt $ANum) {
    $i--
  }
  [uint32]$m = $ANum + $script:B[$i]
  [uint32]$r = [Math]::Floor($m / 18) + 1
  [uint32]$c = $m % 18 + 1
  [string] $out = "{0, 3} ->{1, 2}{2, 3}" -f $ANum, $r, $c
  Write-Output $out
}

# Example elements (atomic numbers)
[int[]]$aNum = 1, 2, 29, 42, 57, 58, 72, 89, 90, 103
foreach ($an in $aNum) {
  Show-Row-And-Column($an)
}
