function Get-Tpk
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
        $Number
    )

    Begin
    {
        function Get-TpkFunction ([double]$Number)
        {
            [Math]::Pow([Math]::Abs($Number),(0.5)) + 5 * [Math]::Pow($Number,3)
        }

        [object[]]$output = @()
    }
    Process
    {
        $Number | ForEach-Object {
            $n = Get-TpkFunction $_

            if ($n -le 400)
            {
                $result = $n
            }
            else
            {
                $result = "Overflow"
            }
        }

        $output += [PSCustomObject]@{
            Number = $Number
            Result = $result
        }
    }
    End
    {
        [Array]::Reverse($output)
        $output
    }
}
