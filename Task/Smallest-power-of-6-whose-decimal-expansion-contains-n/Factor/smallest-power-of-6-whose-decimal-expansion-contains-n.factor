USING: formatting kernel lists lists.lazy math math.functions
present sequences tools.memory.private ;

: powers-of-6 ( -- list )
    0 lfrom [ 6 swap ^ ] lmap-lazy ;

: smallest ( m -- n )
    present powers-of-6 [ present subseq? ] with lfilter car ;

22 [ dup smallest commas "%2d   %s\n" printf ] each-integer
