function Convert-Kelvin
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [double]
        $InputObject
    )

    Process
    {
        foreach ($kelvin in $InputObject)
        {
            [PSCustomObject]@{
                Kelvin     = $kelvin
                Celsius    = $kelvin - 273.15
                Fahrenheit = $kelvin * 1.8 - 459.67
                Rankine    = $kelvin * 1.8
            }
        }
    }
}
