function Get-MersennePrime ([bigint]$Maximum = 4800)
{
    [bigint]$n = [bigint]::One

    for ($exp = 2; $exp -lt $Maximum; $exp++)
    {
        if ($exp -eq 2)
        {
            $s = 0
        }
        else
        {
            $s = 4
        }

        $n = ($n + 1) * 2 - 1

        for ($i = 1; $i -le $exp - 2; $i++)
        {
            $s = ($s * $s - 2) % $n
        }

        if ($s -eq 0)
        {
            $exp
        }
    }
}
