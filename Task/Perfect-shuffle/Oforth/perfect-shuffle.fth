: shuffle(l)     l size 2 / dup l left swap l right zip expand ;
: nbShuffles(l)  1 l while( shuffle dup l <> ) [ 1 under+ ] drop ;
