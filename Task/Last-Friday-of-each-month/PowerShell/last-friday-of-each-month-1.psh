function last-dayofweek {
    param(
     [Int][ValidatePattern("[1-9][0-9][0-9][0-9]")]$year,
     [String][validateset('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')]$dayofweek
    )
    $date = (Get-Date -Year $year -Month 1 -Day 1)
    while($date.DayOfWeek -ne $dayofweek) {$date = $date.AddDays(1)}
    while($date.year -eq $year) {
        if($date.Month -ne $date.AddDays(7).Month) {$date.ToString("yyyy-dd-MM")}
        $date = $date.AddDays(7)
    }
}
last-dayofweek 2012 "Friday"
