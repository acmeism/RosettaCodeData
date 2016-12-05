$numbers = 1..20 | Get-Random -Count 10

foreach ($number in $numbers)
{
    $total = Get-Closure -Number $number

    [PSCustomObject]@{
        Function = $number
        Sum      = & $total -Sum $number
    }
}
