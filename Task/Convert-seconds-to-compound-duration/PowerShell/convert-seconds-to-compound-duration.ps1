function Get-Time
{
  <#
    .SYNOPSIS
        Gets a time string in the form: # wk, # d, # hr, # min, # sec
    .DESCRIPTION
        Gets a time string in the form: # wk, # d, # hr, # min, # sec
        (Values of 0 are not displayed in the string.)

        Days, Hours, Minutes or Seconds in any combination may be used
        as well as Start and End dates.

        When used with the -AsObject switch an object containing properties
        similar to a System.TimeSpan object is returned.
    .INPUTS
        DateTime or Int32
    .OUTPUTS
        String or PSCustomObject
    .EXAMPLE
        Get-Time -Seconds 7259
    .EXAMPLE
        Get-Time -Days 31 -Hours 4 -Minutes 8 -Seconds 16
    .EXAMPLE
        Get-Time -Days 31 -Hours 4 -Minutes 8 -Seconds 16 -AsObject
    .EXAMPLE
        Get-Time -Start 3/10/2016 -End 1/20/2017
    .EXAMPLE
        Get-Time -Start (Get-Date) -End (Get-Date).AddSeconds(6000000)
  #>
    [CmdletBinding(DefaultParameterSetName='Date')]
    Param
    (
        # Start date
        [Parameter(Mandatory=$false, ParameterSetName='Date',
                   Position=0)]
        [datetime]
        $Start = (Get-Date),

        # End date
        [Parameter(Mandatory=$false, ParameterSetName='Date',
                   Position=1)]
        [datetime]
        $End = (Get-Date),

        # Days in the time span
        [Parameter(Mandatory=$false, ParameterSetName='Time')]
        [int]
        $Days = 0,

        # Hours in the time span
        [Parameter(Mandatory=$false, ParameterSetName='Time')]
        [int]
        $Hours = 0,

        # Minutes in the time span
        [Parameter(Mandatory=$false, ParameterSetName='Time')]
        [int]
        $Minutes = 0,

        # Seconds in the time span
        [Parameter(Mandatory=$false, ParameterSetName='Time')]
        [int]
        $Seconds = 0,

        [switch]
        $AsObject
    )

    Begin
    {
        [PSCustomObject]$timeObject = "PSCustomObject" |
            Select-Object -Property Weeks,RemainingDays,
                                    Days,Hours,Minutes,Seconds,Milliseconds,Ticks,
                                    TotalDays,TotalHours,TotalMinutes,TotalSeconds,TotalMilliseconds
        [int]$remainingDays  = 0
        [int]$weeks          = 0

        [string[]]$timeString = @()
    }
    Process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'Date' { $timeSpan = New-TimeSpan -Start $Start -End $End }
            'Time' { $timeSpan = New-TimeSpan -Days $Days -Hours $Hours -Minutes $Minutes -Seconds $Seconds }
        }

        $weeks = [System.Math]::DivRem($timeSpan.Days, 7, [ref]$remainingDays)

        $timeObject.Weeks             = $weeks
        $timeObject.RemainingDays     = $remainingDays
        $timeObject.Days              = $timeSpan.Days
        $timeObject.Hours             = $timeSpan.Hours
        $timeObject.Minutes           = $timeSpan.Minutes
        $timeObject.Seconds           = $timeSpan.Seconds
        $timeObject.Milliseconds      = $timeSpan.Milliseconds
        $timeObject.Ticks             = $timeSpan.Ticks
        $timeObject.TotalDays         = $timeSpan.TotalDays
        $timeObject.TotalHours        = $timeSpan.TotalHours
        $timeObject.TotalMinutes      = $timeSpan.TotalMinutes
        $timeObject.TotalSeconds      = $timeSpan.TotalSeconds
        $timeObject.TotalMilliseconds = $timeSpan.TotalMilliseconds
    }
    End
    {
        if ($AsObject) { return $timeObject }

        if ($timeObject.Weeks)         { $timeString += "$($timeObject.Weeks) wk"        }
        if ($timeObject.RemainingDays) { $timeString += "$($timeObject.RemainingDays) d" }
        if ($timeObject.Hours)         { $timeString += "$($timeObject.Hours) hr"        }
        if ($timeObject.Minutes)       { $timeString += "$($timeObject.Minutes) min"     }
        if ($timeObject.Seconds)       { $timeString += "$($timeObject.Seconds) sec"     }

        return ($timeString -join ", ")
    }
}
