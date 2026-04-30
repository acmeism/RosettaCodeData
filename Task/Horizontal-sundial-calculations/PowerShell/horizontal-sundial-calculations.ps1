function Get-Sundial
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateRange(-90,90)]
        [double]
        $Latitude,


        [Parameter(Mandatory=$true)]
        [ValidateRange(-180,180)]
        [double]
        $Longitude,


        [Parameter(Mandatory=$true)]
        [ValidateRange(-180,180)]
        [double]
        $Meridian
    )

    [double]$sinLat = [Math]::Sin($Latitude*2*[Math]::PI/360)

    $object = [PSCustomObject]@{
        "Sine of Latitude"     = [Math]::Round($sinLat,3)
        "Longitude Difference" = $Longitude - $Meridian
    }

    [int[]]$hours = -6..6

    $hoursArray = foreach ($hour in $hours)
    {
        [double]$hra = (15 * $hour) - ($Longitude - $Meridian)
        [double]$hla = [Math]::Atan($sinLat*[Math]::Tan($hra*2*[Math]::PI/360))*360/(2*[Math]::PI)
        [PSCustomObject]@{
            "Hour"                 = "{0,8}" -f ((Get-Date -Hour ($hour + 12) -Minute 0).ToString("t"))
            "Sun Hour Angle"       = [Math]::Round($hra,3)
            "Dial Hour Line Angle" = [Math]::Round($hla,3)
        }
    }

    $object | Add-Member -MemberType NoteProperty -Name Hours -Value $hoursArray -PassThru
}

$sundial = Get-Sundial -Latitude -4.95 -Longitude -150.5 -Meridian -150
$sundial | Select-Object -Property "Sine of Latitude", "Longitude Difference" | Format-List
$sundial.Hours | Format-Table -AutoSize
