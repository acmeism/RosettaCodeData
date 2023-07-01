import: mapping

: lookAndSay ( n -- )
   [ 1 ] #[ dup .cr group map( [#size, #first] ) expand ] times( n ) ;
