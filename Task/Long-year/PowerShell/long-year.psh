Function Is-Long-Year {
  param([Int]$year)
  53 -eq (Get-Date -Year $year -Month 12 -Day 28 -UFormat %V)
}

For ($y=1995; $y -le 2045; $y++) {
  If (Is-Long-Year $y) {
    Write-Host $y
  }
}
