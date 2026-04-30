function Test-SelfDescribing ([int]$Number)
{
    [int[]]$digits = $Number.ToString().ToCharArray() | ForEach-Object {[Char]::GetNumericValue($_)}
    [int]$sum = 0

    for ($i = 0; $i -lt $digits.Count; $i++)
    {
        $sum += $i * $digits[$i]
    }

    $sum -eq $digits.Count
}
