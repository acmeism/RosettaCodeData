for ($i = 1; $i -lt 11; $i++)
{
    $total = Get-Closure -Number $i

    [PSCustomObject]@{
        Function = $i
        Sum      = & $total -Sum $i
    }
}
