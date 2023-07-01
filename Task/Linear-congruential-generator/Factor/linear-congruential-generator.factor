USING: fry io kernel lists lists.lazy math prettyprint ;

: lcg ( seed a c m quot: ( state -- rand ) -- list )
    [ '[ _ * _ + _ mod ] lfrom-by ] [ lmap-lazy cdr ] bi* ; inline

0 1103515245 12345 2147483648 [ ] lcg           ! bsd
0 214013 2531011 2147483648 [ -16 shift ] lcg   ! ms
[ 10 swap ltake [ . ] leach nl ] bi@
