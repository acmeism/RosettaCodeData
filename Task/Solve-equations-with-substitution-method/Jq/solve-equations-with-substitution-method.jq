# The equation ax + by = c is represented by the array [a, b, c]
def solve( $e1; $e2 ):
    $e1 as [$a1, $b1, $c1]
  | $e2 as [$a2, $b2, $c2]
  | ($b2 * $a1  -  $b1 * $a2 ) as $d
  | if $d == 0 then "there is no unique solution as the discriminant is 0" | error
    else
      {  x : (($b2 * $c1  -  $b1 * $c2 ) / $d) }
      | if   $b1 != 0
        then .y = ( $a1 * .x   -  $c1 ) / -$b1
        else .y = ( $a2 * .x   -  $c2 ) / -$b2
        end
    end;

solve( [3,1,-1]; [2,-3,-19] )
