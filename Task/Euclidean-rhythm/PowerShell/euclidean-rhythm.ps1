# Euclidean rhythm

function Euclidean-Rhythm([uint32]$M, [uint32]$N) {
  $r = [string[]]::new($N)
  [uint32]$aStart = 0
  [uint32]$aEnd = $M - 1
  [uint32]$bStart = $M
  [uint32]$bEnd = $N - 1
  foreach ($i in $aStart..$aEnd) {
    $r[$i] = "1"
  }
  foreach ($i in $bStart..$bEnd) {
    $r[$i] = "0"
  }
  while (($aEnd -gt $aStart) -and ($bEnd -gt $bStart))
  {
    [uint32]$aPos = $aStart
    [uint32]$bPos = $bStart
    while (($aPos -le $aEnd) -and ($bPos -le $bEnd)) {
      $r[$aPos] += $r[$bPos]
      $aPos++
      $bPos++
    }
    if ($bPos -le $bEnd) {
      $bStart = $bPos
    } else {
      $bStart = $aPos
      $bEnd = $aEnd
      $aEnd = $aPos - 1
    }
  }
  [string]$result = ""
  foreach ($i in $aStart..$aEnd) {
    $result += $r[$i]
  }
  foreach ($i in $bStart..$bEnd) {
    $result += $r[$i]
  }
  return $result
}

Write-Output "$(Euclidean-Rhythm 5 13)"
Write-Output "$(Euclidean-Rhythm 3 8)"
