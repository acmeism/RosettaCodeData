USING: kernel math math.functions random sequences ;

: limit ( -- n ) 2 32 ^ ; inline
: in-circle ( x y -- ? ) limit [ sq ] tri@ [ + ] [ <= ] bi* ;
: rand ( -- r ) limit random ;
: pi ( n -- pi ) [ [ drop rand rand in-circle ] count ] keep / 4 * >float ;
