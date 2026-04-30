[datetime]$start = Get-Date

[int]$count = 3

[timespan[]]$times = for ($i = 0; $i -lt $count; $i++)
{
    Measure-Command {0..999999 | Out-Null}
}

[datetime]$end = Get-Date

$rate = [PSCustomObject]@{
    StartTime      = $start
    EndTime        = $end
    Duration       = ($end - $start).TotalSeconds
    TimesRun       = $count
    AverageRunTime = ($times.TotalSeconds | Measure-Object -Average).Average
}

$rate | Format-List
