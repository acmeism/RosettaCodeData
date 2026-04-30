function Get-BalanceStatus ( $String )
    {
    $Open = 0
    ForEach ( $Character in [char[]]$String )
        {
        switch ( $Character )
            {
            "["     { $Open++ }
            "]"     { $Open-- }
            default { $Open = -1 }
            }
        #  If Open drops below zero (close before open or non-allowed character)
        #    Exit loop
        If ( $Open -lt 0 ) { Break }
        }
    $Status = ( "NOT OK", "OK" )[( $Open -eq 0 )]
    return $Status
    }
