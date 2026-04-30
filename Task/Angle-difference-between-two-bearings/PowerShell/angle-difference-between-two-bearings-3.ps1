# Angle difference between two bearings

function Get-Diff([double]$B1, [double]$B2) {
  $r = ($B2 - $B1) % 360.0
  if ($r -lt -180.0) {
    $r += 360.0
  }
  if ($r -ge 180.0) {
    $r -= 360.0
  }
  return [double]$r
}

function Write-Row([double]$B1, [double]$B2) {
  [string]$out = "$($B1.ToString('#######.000000').PadLeft(14,' '))"
  $out += "    $($B2.ToString('#######.000000').PadLeft(14,' '))"
  $out += "    $((Get-Diff $B1 $B2).ToString('#######.000000').PadLeft(14,' '))"
  Write-Output $out
}

Write-Output "Input in -180 to +180 range"
Write-Output "     Bearing 1         Bearing 2        Difference"
Write-Row 20.0 45.0
Write-Row -45.0 45.0
Write-Row -85.0 90.0
Write-Row -95.0 90.0
Write-Row -45.0 125.0
Write-Row -45.0 145.0
Write-Row -45.0 125.0
Write-Row -45.0 145.0
Write-Row 29.4803 -88.6381
Write-Row -78.3251 -159.036
Write-Output ""
Write-Output "Input in wider range"
Write-Output "     Bearing 1         Bearing 2        Difference"
Write-Row -70099.74233810938 29840.67437876723
Write-Row -165313.6666297357 33693.9894517456
Write-Row 1174.8380510598456 -154146.66490124757
Write-Row 60175.77306795546 42213.07192354373
