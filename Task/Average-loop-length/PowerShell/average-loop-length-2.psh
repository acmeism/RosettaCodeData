#  Display results for N = 1 through 20
ForEach ( $N in 1..20 )
    {
    $AnalyticalAverage   = Get-AnalyticalLoopAverage   $N
    $ExperimentalAverage = Get-ExperimentalLoopAverage $N
    [pscustomobject] @{
        N            = $N.ToString().PadLeft( 2, ' ' )
        Analytical   = $AnalyticalAverage.ToString( '0.00000000' )
        Experimental = $ExperimentalAverage.ToString( '0.00000000' )
        'Error (%)'  = ( [math]::Abs( $AnalyticalAverage - $ExperimentalAverage ) / $AnalyticalAverage * 100 ).ToString( '0.00000000' )
        }
    }
