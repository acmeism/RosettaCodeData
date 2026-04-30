$Tests = 1000
ForEach ( $N in 3..6 )
    {
    $Biased   = 0
    $Unbiased = 0

    ForEach ( $Test in 1..$Tests )
        {
        $Biased   += randN $N
        $Unbiased += unbiased $N
        }
    [pscustomobject]@{ N = $N
                       "Biased Ones out of $Test" = $Biased
                       "Unbiased Ones out of $Test" = $Unbiased }
    }
