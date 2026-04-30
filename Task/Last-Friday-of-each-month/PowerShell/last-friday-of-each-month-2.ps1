function Get-Date0fDayOfWeek
{
    [CmdletBinding(DefaultParameterSetName="None")]
    [OutputType([datetime])]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateRange(1,12)]
        [int]
        $Month = (Get-Date).Month,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [ValidateRange(1,9999)]
        [int]
        $Year = (Get-Date).Year,

        [Parameter(Mandatory=$true, ParameterSetName="Sunday")]
        [switch]
        $Sunday,

        [Parameter(Mandatory=$true, ParameterSetName="Monday")]
        [switch]
        $Monday,

        [Parameter(Mandatory=$true, ParameterSetName="Tuesday")]
        [switch]
        $Tuesday,

        [Parameter(Mandatory=$true, ParameterSetName="Wednesday")]
        [switch]
        $Wednesday,

        [Parameter(Mandatory=$true, ParameterSetName="Thursday")]
        [switch]
        $Thursday,

        [Parameter(Mandatory=$true, ParameterSetName="Friday")]
        [switch]
        $Friday,

        [Parameter(Mandatory=$true, ParameterSetName="Saturday")]
        [switch]
        $Saturday,

        [switch]
        $First,

        [switch]
        $Last,

        [switch]
        $AsString,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Format = "dd-MMM-yyyy"
    )

    Process
    {
        [datetime[]]$dates = 1..[DateTime]::DaysInMonth($Year,$Month) | ForEach-Object {
            Get-Date -Year $Year -Month $Month -Day $_ -Hour 0 -Minute 0 -Second 0 |
            Where-Object -Property DayOfWeek -Match $PSCmdlet.ParameterSetName
        }

        if ($First -or $Last)
        {
            if ($AsString)
            {
                if ($First) {$dates[0].ToString($Format)}
                if ($Last)  {$dates[-1].ToString($Format)}
            }
            else
            {
                if ($First) {$dates[0]}
                if ($Last)  {$dates[-1]}
            }
        }
        else
        {
            if ($AsString)
            {
                $dates | ForEach-Object {$_.ToString($Format)}
            }
            else
            {
                $dates
            }
        }
    }
}
