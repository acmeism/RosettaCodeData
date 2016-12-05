def factors:
  . as $in
  | [2, $in, false]
  | recurse( .[0] as $p |.[1] as $q | .[2] as $valid | .[3] as $s
             | if $q == 1        then empty
	       elif $q % $p == 0 then [$p, $q/$p, true]
               elif $p == 2      then [3, $q, false, $s]
               else
	         ($s // ($q | sqrt)) as $s
	         | if $p + 2 <= $s then [$p + 2, $q, false, $s]
      	           else [$q, 1, true]
		   end
	       end )
   | if .[2] then .[0] else empty end ;
