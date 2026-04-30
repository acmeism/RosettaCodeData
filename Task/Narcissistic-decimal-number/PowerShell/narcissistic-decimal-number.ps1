function Test-Narcissistic ([int]$Number)
{
    if ($Number -lt 0) {return $false}

    $total  = 0
    $digits = $Number.ToString().ToCharArray()

    foreach ($digit in $digits)
    {
        $total += [Math]::Pow([Char]::GetNumericValue($digit), $digits.Count)
    }

    $total -eq $Number
}


[int[]]$narcissisticNumbers = @()
[int]$i = 0

while ($narcissisticNumbers.Count -lt 25)
{
    if (Test-Narcissistic -Number $i)
    {
        $narcissisticNumbers += $i
    }

    $i++
}

$narcissisticNumbers | Format-Wide {"{0,7}" -f $_} -Column 5 -Force
