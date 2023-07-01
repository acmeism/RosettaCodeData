USING: dice generalizations kernel math prettyprint sequences ;
IN: rosetta-code.dice-probabilities

: winning-prob ( a b c d -- p )
    [ [ random-roll ] 2bi@ > ] 4 ncurry [ 100000 ] dip replicate
    [ [ t = ] count ] [ length ] bi /f ;

9 4 6 6 winning-prob
5 10 6 7 winning-prob [ . ] bi@
