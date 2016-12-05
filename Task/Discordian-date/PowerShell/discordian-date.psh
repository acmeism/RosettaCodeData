function ConvertTo-Discordian ( [datetime]$GregorianDate )
{
$DayOfYear = $GregorianDate.DayOfYear
$Year = $GregorianDate.Year + 1166
If ( [datetime]::IsLeapYear( $GregorianDate.Year ) -and $DayOfYear -eq 60 )
    { $Day = "St. Tib's Day" }
Else
    {
    If ( [datetime]::IsLeapYear( $GregorianDate.Year ) -and $DayOfYear -gt 60 )
        { $DayOfYear-- }
    $Weekday = @( 'Sweetmorn', 'Boomtime', 'Pungenday', 'Prickle-Prickle', 'Setting Orange' )[(($DayOfYear - 1 ) % 5 )]
    $Season  = @( 'Chaos', 'Discord', 'Confusion', 'Bureaucracy', 'The Aftermath' )[( [math]::Truncate( ( $DayOfYear - 1 ) / 73 ) )]
    $DayOfSeason = ( $DayOfYear - 1 ) % 73 + 1
    $Day = "$Weekday, $Season $DayOfSeason"
    }
$DiscordianDate = "$Day, $Year YOLD"
return $DiscordianDate
}

ConvertTo-Discordian ([datetime]'1/5/2016')
ConvertTo-Discordian ([datetime]'2/29/2016')
ConvertTo-Discordian ([datetime]'12/8/2016')
