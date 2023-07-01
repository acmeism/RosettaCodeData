function Get-CatalanNumber
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [uint32[]]
        $InputObject
    )

    Begin
    {
        function Get-Factorial ([int]$Number)
        {
            if ($Number -eq 0)
            {
                return 1
            }

            $factorial = 1

            1..$Number | ForEach-Object {$factorial *= $_}

            $factorial
        }

        function Get-Catalan ([int]$Number)
        {
            if ($Number -eq 0)
            {
                return 1
            }

            (Get-Factorial (2 * $Number)) / ((Get-Factorial (1 + $Number)) * (Get-Factorial $Number))
        }
    }
    Process
    {
        foreach ($number in $InputObject)
        {
            [PSCustomObject]@{
                Number        = $number
                CatalanNumber = Get-Catalan $number
            }
        }
    }
}
