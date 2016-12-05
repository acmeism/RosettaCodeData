function Get-DigitalSum ([string] $number, $base = 10)
{
    if ($number.ToCharArray().Length -le 1) { [Convert]::ToInt32($number, $base) }
    else
    {
        $result = 0
        foreach ($character in $number.ToCharArray())
        {
            $digit = [Convert]::ToInt32(([string]$character), $base)
            $result += $digit
        }
        return $result
    }
}
