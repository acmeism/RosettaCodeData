USING: backtrack compiler.tree.propagation.call-effect
formatting io kernel sequences sequences.generalizations
tools.memory.private tools.time ;

: d ( digit -- digit next-digit )
    dup {
        { 2 3 5 7 }         ! from 0 we can get to these digits
        { 3 4 6 8 }         ! from 1 we can get to these
        { 0 4 5 7 9 }       ! etc...
        { 0 1 5 6 8 }
        { 1 2 6 7 9 }
        { 0 2 3 7 8 }
        { 1 3 4 8 9 }
        { 0 2 4 5 9 }
        { 1 3 5 6 }
        { 2 4 6 7 }
    } nth amb-lazy ;

[ [ 1 d d d d d d d d d 10 narray ] bag-of ] time

dup length commas write
" 10-digit strange numbers beginning with 1:" print
[ first2 ] [ last2 ] bi "%u\n%u\n...\n%u\n%u\n" printf
