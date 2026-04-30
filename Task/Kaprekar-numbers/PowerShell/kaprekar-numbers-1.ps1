function Test-Kaprekar ([int]$Number)
{
    if ($Number -eq 1)
    {
        return $true
    }

    [int64]$a = $Number * $Number
    [int64]$b = 10

    while ($b -lt $a)
    {
        [int64]$remainder = $a % $b
        [int64]$quotient  = ($a - $remainder) / $b

        if ($remainder -gt 0 -and $remainder + $quotient -eq $Number)
        {
            return $true
        }

        $b *= 10
    }

    return $false
}
