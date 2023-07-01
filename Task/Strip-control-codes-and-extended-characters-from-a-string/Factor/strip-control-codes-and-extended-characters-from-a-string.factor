USING: ascii kernel sequences ;

: strip-control-codes ( str -- str' ) [ control? not ] filter ;

: strip-control-codes-and-extended ( str -- str' )
    strip-control-codes [ ascii? ] filter ;
