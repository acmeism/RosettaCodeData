USING: kernel math.order qw sequences sorting ;

: fn ( seq -- str )
    [ 2dup swap [ append ] 2bi@ after? +lt+ +gt+ ? ] sort concat ;
