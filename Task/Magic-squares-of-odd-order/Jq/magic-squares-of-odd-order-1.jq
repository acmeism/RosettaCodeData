def odd_magic_square:
  if type != "number" or . % 2 == 0 or . <= 0
  then error("odd_magic_square requires an odd positive integer")
  else
    . as $n
    | reduce range(1; 1 + ($n*$n)) as $i
         ( [0, (($n-1)/2), []];
 	  .[0] as $x | .[1] as $y
          | .[2]
	  | setpath([$x, $y]; $i )
          | if getpath([(($x+$n-1) % $n), (($y+$n+1) % $n)])
            then [(($x+$n+1) % $n), $y, .]
            else [ (($x+$n-1) % $n), (($y+$n+1) % $n), .]
 	    end )  | .[2]
  end ;
