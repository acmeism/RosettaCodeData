function Get-NumberClassification
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [int]
        $Number
    )

    Begin
    {
        function Get-ProperDivisorSum ([int]$Number)
        {
            if ($Number -lt 2) {return 0}

            $sum = 1

            if ($Number -gt 3)
            {
                $sqrtNumber = [Math]::Sqrt($Number)

                foreach ($divisor in 2..$sqrtNumber)
                {
                    if ($Number % $divisor -eq 0) {$sum += $divisor + $Number / $divisor}
                }

                if ($Number % $sqrtNumber -eq 0) {$sum -= $sqrtNumber}
            }

            $sum
        }

        [System.Collections.ArrayList]$numbers = @()
    }
    Process
    {
        switch ([Math]::Sign((Get-ProperDivisorSum $Number) - $Number))
        {
            -1 { [void]$numbers.Add([PSCustomObject]@{Class="Deficient"; Number=$Number}) }
             0 { [void]$numbers.Add([PSCustomObject]@{Class="Perfect"  ; Number=$Number}) }
             1 { [void]$numbers.Add([PSCustomObject]@{Class="Abundant" ; Number=$Number}) }
        }
    }
    End
    {
        $numbers | Group-Object  -Property Class |
                   Select-Object -Property Count,
                                           @{Name='Class' ; Expression={$_.Name}},
                                           @{Name='Number'; Expression={$_.Group.Number}}
    }
}
