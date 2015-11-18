$fiveWeekends = @()
$yearsWithout = @()
foreach ($y in 1900..2100) {
  $hasFiveWeekendMonth = $FALSE
  foreach ($m in @("01","03","05","07","08",10,12)) {
    if ((Get-Date "$y-$m-1").DayOfWeek -eq "Friday") {
      $fiveWeekends += "$y-$m"
      $hasFiveWeekendMonth = $TRUE
    }
  }
  if ($hasFiveWeekendMonth -eq $FALSE) {
     $yearsWithout += $y
  }
}
Write-Output "Between the years 1900 and 2100, inclusive, there are $($fiveWeekends.count) months with five full weekends:"
Write-Output "$($fiveWeekends[0..4] -join ","),...,$($fiveWeekends[-5..-1] -join ",")"

Write-Output ""
Write-Output "Extra Credit: these $($yearsWithout.count) years have no such month:"
Write-Output ($yearsWithout -join ",")
