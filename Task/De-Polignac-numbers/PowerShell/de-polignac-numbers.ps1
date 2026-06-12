# De Polignac numbers

$script:MaxNumber = 500000 # maximum number we will consider
$script:MaxPower  =     20 # maximum power of 2 < MaxNumber

# sieve the primes to $script:MaxNumber
$prime = [bool[]]::new($script:MaxNumber + 1)
$prime[0] = $false
$prime[1] = $false
$prime[2] = $true
for ($i = 3; $i -le $script:MaxNumber; $i += 2) {
  $prime[$i] = $true
}
for ($i = 4; $i -le $script:MaxNumber; $i += 2) {
  $prime[$i] = $false
}
$rootMaxNumber = [math]::Floor([math]::Sqrt($script:MaxNumber))
for ($i = 3; $i -le $rootMaxNumber; $i += 2) {
  if ($prime[$i]) {
    [uint32]$di = $i + $i
    for ($s = $i * $i; $s -le $script:MaxNumber; $s += $di) {
      $prime[$s] = $false
    }
  }
}

# Table of $powersOf2 up to around 2000000
# Increase the table size if $script:MaxNumber > 2000000
$powersOf2 = [uint32[]]::new($script:MaxPower + 1)
$p2 = 1
$powersOf2[0] = $p1 # unused
foreach ($i in 1..$script:MaxPower) {
  $p2 *= 2
  $powersOf2[$i] = $p2
}
# The numbers must be odd and not of the form p + 2^n
# Either p is odd and 2^n is even and hence n > 0 and p > 2
# or 2^n is odd and p is even and hence n = 0 and p = 2
# (the only even prime is 2, the only odd 2^n is 1).
[string]$row = @()
# n = 0, p = 2
$dpCount = 1
$row += "{0, 5}" -f 1
# n > 0, p > 2
for ($i = 5; $i -le $script:MaxNumber; $i += 2) {
  [bool]$found = $false
  for ($p = 1; ($p -le $script:MaxPower) -and (-not $found) -and ($i -gt $powersOf2[$p]); $p++) {
    $found = $prime[$i - $powersOf2[$p]]
  }
  if (-not $found) {
    $dpCount++
    if ($dpCount -le 50) {
      $row += "{0, 5}" -f $i
      if (($dpCount % 10) -eq 0) {
        Write-Output $row
        $row = ""
      }
    } elseif (($dpCount -eq 1000) -or ($dpCount -eq 10000)) {
      $out1 = "The {0,5}th de Polignac number is {1,7}" -f $dpCount, $i
      Write-Output $out1
    }
  }
}
Write-Output "Found $($dpCount) de Polignac numbers up to $($script:MaxNumber)"
