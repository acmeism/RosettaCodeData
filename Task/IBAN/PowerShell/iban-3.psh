$regex = [regex]'[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{6}[0-9]{5}([a-zA-Z0-9]?){0,16}'

foreach ($iban in $ibans)
{
    [PSCustomObject]@{
        Country = $iban.Country
        Example = $iban.Example
        IsValid = $regex.IsMatch($iban.Example)
    }
}
