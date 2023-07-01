[int]$count = 0
[int]$maxCount = 0
[datetime[]]$times = @()

$jobs = Get-Content -Path ".\mlijobs.txt" | ForEach-Object {
    [string[]]$fields   = $_.Split(" ",[StringSplitOptions]::RemoveEmptyEntries)
    [datetime]$datetime = Get-Date $fields[3].Replace("_"," ")
    [PSCustomObject]@{
        State = $fields[1]
        Date  = $datetime
        Job   = $fields[6]
    }
}

foreach ($job in $jobs)
{
    switch ($job.State)
    {
        "IN"
        {
            $count--
        }
        "OUT"
        {
            $count++

            if ($count -gt $maxCount)
            {
                $maxCount = $count
                $times = @()
                $times+= $job.Date
            }
            elseif ($count -eq $maxCount)
            {
                $times+= $job.Date
            }
        }
    }
}

[PSCustomObject]@{
    LicensesOut = $maxCount
    StartTime   = $times[0]
    EndTime     = $times[1]
}
