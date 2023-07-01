USE: eval
: eval-bi@- ( a b program -- n )
    tuck [ ( y -- z ) eval ] 2bi@ - ;
