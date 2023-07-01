function Get-MeanTimeOfDay
{
    [CmdletBinding()]
    [OutputType([timespan])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern("(?:2[0-3]|[01]?[0-9])[:.][0-5]?[0-9][:.][0-5]?[0-9]")]
        [string[]]
        $Time
    )

    Begin
    {
        [double[]]$angles = @()

        function ConvertFrom-Time ([timespan]$Time)
        {
            [double]((360 * $Time.Hours / 24) + (360 * $Time.Minutes / (24 * 60)) + (360 * $Time.Seconds / (24 * 3600)))
        }

        function ConvertTo-Time ([double]$Angle)
        {
            $t = New-TimeSpan -Hours   ([int](24 * 60 * 60 * $Angle / 360) / 3600) `
                              -Minutes (([int](24 * 60 * 60 * $Angle / 360) % 3600 - [int](24 * 60 * 60 * $Angle / 360) % 60) / 60) `
                              -Seconds ([int]((24 * 60 * 60 * $Angle / 360) % 60))

            if ($t.Days -gt 0)
            {
                return ($t - (New-TimeSpan -Hours 1))
            }

            $t
        }

        function Get-MeanAngle ([double[]]$Angles)
        {
            [double]$x,$y = 0

            for ($i = 0; $i -lt $Angles.Count; $i++)
            {
                $x += [Math]::Cos($Angles[$i] * [Math]::PI / 180)
                $y += [Math]::Sin($Angles[$i] * [Math]::PI / 180)
            }

            $result = [Math]::Atan2(($y / $Angles.Count), ($x / $Angles.Count)) * 180 / [Math]::PI

            if ($result -lt 0)
            {
                return ($result + 360)
            }

            $result
        }
    }
    Process
    {
        $angles += ConvertFrom-Time $_
    }
    End
    {
        ConvertTo-Time (Get-MeanAngle $angles)
    }
}
