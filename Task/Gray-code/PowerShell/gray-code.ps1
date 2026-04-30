# Gray code

function Encode {
  [OutputType([uint32])]
  param([uint32]$V)

  return $V -bxor ($V -shr 1)
}

function Decode {
  [OutputType([uint32])]
  param([uint32]$V)

  [uint32]$result = 0
  while ($V -gt 0) {
    $result = $result -bxor $V
    $V = $V -shr 1
  }
  return $result
}

Write-Output "decimal  binary   gray    decoded"
foreach ($i in 0..31) {
  [uint32]$g = Encode($i)
  [uint32]$d = Decode($g)
  [string]$out = @()
  $out += "{0, 4}     " -f $i
  $binS = ([convert]::ToString($i, 2)).PadLeft(5, "0")
  $out += "$binS   "
  $binS = ([convert]::ToString($g, 2)).PadLeft(5, "0")
  $out += "$binS   "
  $binS = ([convert]::ToString($d, 2)).PadLeft(5, "0")
  $out += "$binS{0, 4}" -f $d
  Write-Output $out
}
