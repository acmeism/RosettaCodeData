def squares(n):
  reduce range(1; 1+n) as $i ({}; .[$i*$i|tostring] = $i);

# if count, then just count
def solve(angle; maxLen; allowSame; count):
  squares(maxLen) as $squares

  | def qsqrt($n):
    $squares[$n|tostring] as $sqrt
    | if $sqrt then $sqrt else null end;

  reduce range(1; maxLen+1) as $a ({};
      reduce range($a; maxLen+1) as $b (.;
        .lhs = $a*$a + $b*$b
        | if angle != 90
          then if angle == 60
               then .lhs += ( - $a*$b)
               elif angle == 120
               then .lhs +=  $a*$b
               else "Angle must be 60, 90 or 120 degrees" | error
               end
          else .
          end
        | qsqrt(.lhs) as $c
        | if $c != null
          then if allowSame or $a != $b or $b != $c
               then .solutions += if count then 1 else [[$a, $b, $c]] end
               else .
               end
           else .
           end
        )
    )
  | .solutions ;

def task1($angles):
  "For sides in the range [1, 13] where they can all be of the same length:\n",
  ($angles[]
   | . as $angle
   | solve($angle; 13; true; false)
   | "  For an angle of \($angle) degrees, there are \(length) solutions, namely:", .);

def task2(degrees; n):
  "For sides in the range [1, \(n)] where they cannot ALL be of the same length:",
  (solve(degrees; n; false; true)
   | "  For an angle of \(degrees) degrees, there are \(.) solutions.") ;

task1([90, 60, 120]), "", task2(60; 10000)
