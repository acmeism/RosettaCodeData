# Statistics/Normal distribution

# Generates normally distributed random numbers with $mean 0 and standard deviation 1
function Get-RandomNormal {
  return [Math]::Cos(2.0 * [Math]::PI * (Get-Random -Maximum 1.0)) * [Math]::Sqrt(-2.0 * [Math]::Log((Get-Random -Maximum 1.0)))
}

function Write-NormalStats {
  param ([uint32]$SampleSize)
  if ($SampleSize -lt 1) {
    return
  }
  $r = [double[]]::new($SampleSize)
  $h = [uint32[]]::new(12) # all zero by default
  $sum = 0.0
  $hSum = 0

  # Generate '$SampleSize' normally distributed random numbers with $mean 0.5 and standard deviation 0.25
  # calculate their $sum
  # and in which box they will fall when drawing the histogram
  $iTo = $SampleSize - 1
  foreach ($i in 0..$iTo) {
    $r[$i] = .5 + $(Get-RandomNormal) / 4.0
    $sum += $r[$i]
    if ($r[$i] -lt 0.0) {
      $h[0]++
    } elseif ($r[$i] -ge 1.0) {
      $h[11]++
    } else {
      $h[[Math]::Ceiling($r[$i] * 10)]++
    }
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
  # If sample size > 300 then normalize histogram to 300
  $scale = 1.0
  if ($SampleSize -gt 300) {
    $scale = 300.0 / $SampleSize
  }
  Write-Output "Sample size  $SampleSize"
  Write-Output ('  Mean {0,8:N6}  SD {1,8:N6}' -f $mean, $sd)
  $i = -1
  foreach ($hItem in $h) {
    if ($i -eq -1) {
      $out = '< 0.00 : '
    } elseif ($i -eq 10) {
      $out = '>=1.00 : '
    } else {
      $out = '  {0,4:N2} : ' -f ($i / 10.0)
    }
    $out += ('{0,5} ' -f $hItem)
    Write-Output ($out + ('*' * [Math]::Round($hItem * $scale)))
    $i++
  }
}

Write-NormalStats 100
Write-Output ""
Write-NormalStats 1000
Write-Output ""
Write-NormalStats 10000
Write-Output ""
