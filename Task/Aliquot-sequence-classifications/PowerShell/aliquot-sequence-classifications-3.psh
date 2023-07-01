function Get-Aliquot
{
    [CmdletBinding()]
    [OutputType([PScustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [int]
        $InputObject
    )

    Begin
    {
        function Get-NextAliquot ([int]$X)
        {
            if ($X -gt 1)
            {
                $nextAliquot = 1

                if ($X -gt 2)
                {
                    $xSquareRoot = [Math]::Sqrt($X)

                    2..$xSquareRoot | Where-Object {$X % $_ -eq 0} | ForEach-Object {$nextAliquot += $_ + $x / $_}

                    if ($xSquareRoot % 1 -eq 0) {$nextAliquot -= $xSquareRoot}
                }

                $nextAliquot
            }
        }

        function Get-AliquotSequence ([int]$K, [int]$N)
        {
            $X = $K
            $X
            $i = 1

            while ($X -and $i -lt $N)
            {
                $i++
                $next = Get-NextAliquot $X

                if ($next)
                {
                    if ($X -eq $next)
                    {
                        $i..$N  | ForEach-Object {$X}
                        $i = $N
                    }
                    else
                    {
                        $X = $next
                        $X
                    }
                }
                else
                {
                    $i = $N
                }
            }
        }

        function Classify-AlliquotSequence ([int[]]$Sequence)
        {
            $k = $Sequence[0]

            if ($Sequence[-1] -eq 0)                                     {return "terminating"}
            if ($Sequence[-1] -eq 1)                                     {return "terminating"}
            if ($Sequence[1]  -eq $k)                                    {return "perfect"    }
            if ($Sequence[2]  -eq $k)                                    {return "amicable"   }
            if ($Sequence[3..($Sequence.Count-1)] -contains $k)          {return "sociable"   }
            if ($Sequence[-1] -eq $Sequence[-2] )                        {return "aspiring"   }
            if ($Sequence.Count -gt ($Sequence | Select -Unique).Count ) {return "cyclic"     }

            return "non-terminating and non-repeating through N = $($Sequence.Count)"
        }
    }
    Process
    {
        $_ | ForEach-Object {
            [PSCustomObject]@{
                Number         = $_
                Classification = (Classify-AlliquotSequence -Sequence (Get-AliquotSequence -K $_ -N 16))
            }
        }
    }
}
