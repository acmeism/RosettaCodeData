function Get-Ackermann ([int64]$m, [int64]$n)
{
    if ($m -eq 0)
    {
        return $n + 1
    }

    if ($n -eq 0)
    {
        return Get-Ackermann ($m - 1) 1
    }

    return (Get-Ackermann ($m - 1) (Get-Ackermann $m ($n - 1)))
}
