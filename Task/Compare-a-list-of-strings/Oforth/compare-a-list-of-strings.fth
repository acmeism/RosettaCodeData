: lexEqual   asSet size 1 <= ;
: lexCmp(l)  l l right( l size 1- ) zipWith(#<) and ;
