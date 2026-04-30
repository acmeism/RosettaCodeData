function Select-NumberFromString
{
    [CmdletBinding(DefaultParameterSetName="Decimal")]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $InputObject,

        [Parameter(ParameterSetName="Decimal")]
        [Alias("d","Dec")]
        [switch]
        $Decimal,

        [Parameter(ParameterSetName="Hexadecimal")]
        [Alias("h","Hex")]
        [switch]
        $Hexadecimal,

        [Parameter(ParameterSetName="Octal")]
        [Alias("o","Oct")]
        [switch]
        $Octal,

        [Parameter(ParameterSetName="Binary")]
        [Alias("b","Bin")]
        [switch]
        $Binary
    )

    Begin
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            "Decimal"     {$base = 10; $pattern = '[+-]?\b[0-9]+\b'; break}
            "Hexadecimal" {$base = 16; $pattern = '\b[0-9A-F]+\b'  ; break}
            "Octal"       {$base =  8; $pattern = '\b[0-7]+\b'     ; break}
            "Binary"      {$base =  2; $pattern = '\b[01]+\b'      ; break}
            "Default"     {$base = 10; $pattern = '[+-]?\b[0-9]+\b'; break}
        }
    }
    Process
    {
        foreach ($object in $InputObject)
        {
            if ($object -match $pattern)
            {
                $string = $Matches[0]
            }
            else
            {
                $string = $null
            }


            try
            {
                $value = [Convert]::ToInt32($string, $base)
            }
            catch
            {
                $value = $null
            }

            [PSCustomObject]@{
                Number      = $value
                String      = $string
                Base        = $base
                IsNumber    = $value -is [int]
                InputString = $object
            }

        }
    }
}
