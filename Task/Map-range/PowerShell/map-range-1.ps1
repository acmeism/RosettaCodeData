function Group-Range
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidateCount(2,2)]
        [double[]]
        $Range1,

        [Parameter(Mandatory=$true,
                   Position=1)]
        [ValidateCount(2,2)]
        [double[]]
        $Range2,

        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=2)]
        [double]
        $Map
    )

    Process
    {
        foreach ($number in $Map)
        {
            [PSCustomObject]@{
                Index   = $number
                Mapping = $Range2[0] + ($number - $Range1[0]) * ($Range2[0] - $Range2[1]) / ($Range1[0] - $Range1[1])
            }
        }
    }
}
