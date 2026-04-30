# Statistics/Basic

function Write-BasicStats {
  param ([uint32]$SampleSize)
  if ($SampleSize -lt 1) {
    return
  }

  $r = [double[]]::new($SampleSize)
  $h = [uint32[]]::new(10) # all zero by default
  $sum = 0.0
  $hSum = 0

  # Generate '$SampleSize' random numbers in the interval [0, 1)
  # calculate their $sum
  # and in which box they will fall when drawing the histogram
  $iTo = $SampleSize - 1
  foreach ($i in 0..$iTo) {
    $r[$i] = (Get-Random -Maximum 1.0)
    $sum += $r[$i]
    $h[[Math]::floor($r[$i] * 10)]++
  }
  foreach ($hItem in $h) {
    $hSum += $hItem
  }
  # adjust one of the $h[] values if necessary to ensure $hSum = $SampleSize
  $adj = $SampleSize - $hSum
  if ($adj -ne 0) {
    $iTo = $h.Length - 1
    foreach ($i in 0..$iTo) {
      $h[$i] += $adj
      if ($h[$i] -ge 0) {
        break
      }
      $h[$i] -= $adj
    }
  }
  $mean = $sum / $SampleSize

  $sum = 0.0
  # Now calculate their standard deviation
  foreach ($rItem in $r) {
    $sum += [Math]::Pow($rItem - $mean, 2)
  }
  $sd = [Math]::Sqrt($sum / $SampleSize)

  # Draw a histogram of the data with interval 0.1
  # If sample size > 500 then normalize histogram to 500
  [double]$scale = 1.0
  if ($SampleSize -gt 500) {
    $scale = 500.0 / $SampleSize
  }
  Write-Output "Sample size $SampleSize"
  Write-Output ('  Mean {0,8:N6}  SD {1,8:N6}' -f $mean, $sd)
  $i = 0
  foreach ($hItem in $h) {
    $out = '  {0,4:N2} : {1,5} ' -f ($i / 10.0), $hItem
    Write-Output ($out + ('*' * [Math]::Round($hItem * $scale)))
    $i++
  }
}

Write-BasicStats 100
Write-Output ""
Write-BasicStats 1000
Write-Output ""
Write-BasicStats 10000
Write-Output ""
