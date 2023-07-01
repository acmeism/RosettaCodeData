SYMBOL: x
: eval-with-x ( a b program -- n )
    tuck
    [ [ x ] dip [ ( -- y ) eval ] curry with-variable ] 2bi@ - ;
