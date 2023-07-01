def cumu:
  . as $n
  | reduce range(1; $n+1) as $l ( {cache: [[1]]};
      .r = [0]
      | reduce range(1; $l+1) as $x (.;
          .min = $l - $x
          | if ($x < .min) then .min = $x else . end
          | .r = .r + [.r[-1] + .cache[$l - $x][.min] ] )
      | .cache = .cache + [.r] )
  | .cache[$n] ;

def row:
  cumu as $r
  | reduce range(0; .) as $i ([]; . + [$r[$i+1] - $r[$i]] );

def task:
  "Rows:",
  (range(1; 26) |  [ ., row]),
  "\nSums:",
  ( (23, 123, 1234)   #  12345 is a stretch for memory even using wren
   | [., cumu[-1]] ) ;
