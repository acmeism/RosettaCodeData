function Get-ChristmasHoliday
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateRange(1,9999)]
        [int[]]
        $Year = (Get-Date).Year
    )

    Process
    {
        [datetime]$christmas = Get-Date $Year/12/25

        switch ($christmas.DayOfWeek)
        {
            "Sunday"   {[datetime[]]$dates = 1..5 | ForEach-Object {$christmas.AddDays($_)}}
            "Monday"   {[datetime[]]$dates = $christmas, $christmas.AddDays(1)}
            "Saturday" {[datetime[]]$dates = $christmas.AddDays(-2), $christmas.AddDays(-1)}
            Default    {[datetime[]]$dates = $christmas.AddDays(-1), $christmas}
        }

        $dates | Group-Object  -Property Year |
                 Select-Object -Property @{Name="Year"     ; Expression={$_.Name}},
                                         @{Name="DayOfWeek"; Expression={$christmas.DayOfWeek}},
                                         @{Name="Christmas"; Expression={$christmas.ToString("MM/dd/yyyy")}},
                                         @{Name="DaysOff"  ; Expression={$_.Group | ForEach-Object {$_.ToString("MM/dd/yyyy")}}}
    }
}
