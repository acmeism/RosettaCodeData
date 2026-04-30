# Abundant odd numbers

# Returns the sum of the proper divisors of $N
function Divisor-Sum([uint32]$N) {
  [uint32]$sum = 1
  [uint32]$intSqrtN = [uint32]([Math]::Sqrt($N))
  for ($d = 2; $d -le $intSqrtN; $d++) {
    # The for loop is used because foreach goes downwards if $intSqrtN < 2
    if ($N % $d -eq 0) {
      $sum += $d
      [uint32]$otherD = $N / $d
      if ($otherD -ne $d) {
        $sum += $otherD
      }
    }
  }
  return $sum
}

# first 25 odd abundant numbers
[uint32]$oddNumber = 1
[uint32]$aCount = 0
[uint32]$dSum = 0
Write-Output "The first 25 abundant odd numbers:"
while ($aCount -lt 25) {
  $dSum = Divisor-Sum $oddNumber
  if ($dSum -gt $oddNumber) {
    $aCount++
    [string]$out = "{0, 6} proper divisor sum: {1, 6}" -f $oddNumber, $dSum
    Write-Output $out
  }
  $oddNumber += 2
}

# 1000th odd abundant number
while ($aCount -lt 1000) {
  $dSum = Divisor-Sum $oddNumber
  if ($dSum -gt $oddNumber) {
    $aCount++
  }
  $oddNumber += 2
}
Write-Output "1000th abundant odd number:"
Write-Output "    $($oddNumber - 2) proper divisor sum: $dSum"

# first odd abundant number > 1000000000
$oddNumber = 1000000001
[bool]$found = $false
while (-not $found) {
  $dSum = Divisor-Sum $oddNumber
  if ($dSum -gt $oddNumber) {
      $found = $true
      Write-Output "First abundant odd number > 1 000 000 000:"
      Write-Output "    $oddNumber proper divisor sum: $dSum"
  }
  $oddNumber += 2
}
