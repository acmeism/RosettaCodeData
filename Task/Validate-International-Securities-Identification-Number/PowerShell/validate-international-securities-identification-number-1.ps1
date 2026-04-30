function Test-ISIN
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidatePattern("[A-Z]{2}\w{9}\d")]
        [ValidateScript({$_.Length -eq 12})]
        [string]
        $Number
    )

    function Split-Array
    {
        $array = @(), @()
        $input | ForEach-Object {$array[($index = -not $index)] += $_}
        $array[1], $array[0]
    }

    filter ConvertTo-Digit
    {
        if ($_ -gt 9)
        {
            $_.ToString().ToCharArray() | ForEach-Object -Begin {$n = 0} -Process {$n += [Char]::GetNumericValue($_)} -End {$n}
        }
        else
        {
            $_
        }
    }


    $checkDigit = $Number[-1]

    $digits = ($Number -replace ".$").ToCharArray() | ForEach-Object {
        if ([Char]::IsDigit($_))
        {
            [Char]::GetNumericValue($_)
        }
        else
        {
            [int][char]$_ - 55
        }
    }

    $odds, $evens = ($digits -join "").ToCharArray() | Split-Array

    if ($odds.Count -gt $evens.Count)
    {
        $odds  = $odds  | ForEach-Object {[Char]::GetNumericValue($_) * 2} | ConvertTo-Digit
        $evens = $evens | ForEach-Object {[Char]::GetNumericValue($_)}
    }
    else
    {
        $odds  = $odds  | ForEach-Object {[Char]::GetNumericValue($_)}
        $evens = $evens | ForEach-Object {[Char]::GetNumericValue($_) * 2} | ConvertTo-Digit
    }

    $sum = ($odds  | Measure-Object -Sum).Sum + ($evens | Measure-Object -Sum).Sum

    (10 - ($sum % 10)) % 10 -match $checkDigit
}
