# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Input is $d, the number of consecutive digits, 2 <= $d <= 9
# $max is the number of superd numbers to be emitted.
def superd($number):
  . as $d
  | tostring as $s
  | ($s * $d) as $target
  | {count:0, j: 3 }
  |  while ( .count <= $number;
        .emit = null
        | if ((.j|power($d) * $d) | tostring) | index($target)
          then .count += 1
          | .emit = .j
	  else .
          end
        | .j += 1 )
   | select(.emit).emit ;

# super-d for 2 <=d < 8
range(2; 8)
| "First 10 super-\(.) numbers:",
   superd(10)
