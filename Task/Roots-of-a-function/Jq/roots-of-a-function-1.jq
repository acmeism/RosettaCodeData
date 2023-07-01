def sign:
  if . < 0 then -1 elif . > 0 then 1 else 0 end;

def printRoots(f; lowerBound; upperBound; step):
 lowerBound as $x
 | ($x|f) as $y
 | ($y|sign) as $s
 | reduce range($x; upperBound+step; step) as $x
   # state: [ox, oy, os, roots]
   ( [$x, $y, $s, [] ];
     .[0] as $ox | .[1] as $oy | .[2] as $os
     | ($x|f) as $y
     | ($y | sign) as $s
     | if $s == 0 then  [$x, $y, $s, (.[3] + [$x] )]
       elif $s != $os and $os != 0 then
	  ($x - $ox) as $dx
          | ($y - $oy) as $dy
    	  | ($x - ($dx *  $y / $dy)) as $cx       # by geometry
          | [$x, $y, $s, (.[3] + [ "~\($cx)" ])]  # an approximation
       else [$x, $y, $s, .[3] ]
       end )
  | .[3] ;
