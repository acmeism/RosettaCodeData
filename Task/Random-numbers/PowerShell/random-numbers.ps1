function Get-RandomNormal
    {
    [CmdletBinding()]
    Param ( [double]$Mean, [double]$StandardDeviation )

    $RandomNormal = $Mean + $StandardDeviation * [math]::Sqrt( -2 * [math]::Log( ( Get-Random -Minimum 0.0 -Maximum 1.0 ) ) ) * [math]::Cos( 2 * [math]::PI * ( Get-Random -Minimum 0.0 -Maximum 1.0 ) )

    return $RandomNormal
    }

#  Standard deviation function for testing
function Get-StandardDeviation
    {
    [CmdletBinding()]
    param ( [double[]]$Numbers )

    $Measure = $Numbers | Measure-Object -Average
    $PopulationDeviation = 0
    ForEach ($Number in $Numbers) { $PopulationDeviation += [math]::Pow( ( $Number - $Measure.Average ), 2 ) }
    $StandardDeviation = [math]::Sqrt( $PopulationDeviation / ( $Measure.Count - 1 ) )
    return $StandardDeviation
    }

#  Test
$RandomNormalNumbers = 1..1000 | ForEach { Get-RandomNormal -Mean 1 -StandardDeviation 0.5 }

$Measure = $RandomNormalNumbers | Measure-Object -Average

$Stats = [PSCustomObject]@{
    Count             = $Measure.Count
    Average           = $Measure.Average
    StandardDeviation = Get-StandardDeviation -Numbers $RandomNormalNumbers
}

$Stats | Format-List
