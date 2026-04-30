function Get-LevenshteinDistance
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [Alias("s")]
        [string]
        $ReferenceObject,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [Alias("t")]
        [string]
        $DifferenceObject
    )

    [int]$n = $ReferenceObject.Length
    [int]$m = $DifferenceObject.Length

    $d = New-Object -TypeName 'System.Object[,]' -ArgumentList ($n + 1),($m + 1)

    $outputObject = [PSCustomObject]@{
        ReferenceObject  = $ReferenceObject
        DifferenceObject = $DifferenceObject
        Distance         = $null
    }

    for ($i = 0; $i -le $n; $i++)
    {
        $d[$i, 0] = $i
    }

    for ($i = 0; $i -le $m; $i++)
    {
        $d[0, $i] = $i
    }

    for ($i = 1; $i -le $m; $i++)
    {
        for ($j = 1; $j -le $n; $j++)
        {
            if ($ReferenceObject[$j - 1] -eq $DifferenceObject[$i - 1])
            {
                $d[$j, $i] = $d[($j - 1), ($i - 1)]
            }
            else
            {
                $d[$j, $i] = [Math]::Min([Math]::Min(($d[($j - 1), $i] + 1), ($d[$j, ($i - 1)] + 1)), ($d[($j - 1), ($i - 1)] + 1))
            }
        }
    }

    $outputObject.Distance = $d[$n, $m]

    $outputObject
}
