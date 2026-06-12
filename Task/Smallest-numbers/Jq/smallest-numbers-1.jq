# if the input and $b are integers, then gojq will preserve precision
def power($b): . as $a | reduce range(0; $b) as $i (1; . * $a);

def smallest_k:
  tostring as $n
  | first( range(1; infinite) | select( power(.) | tostring | contains($n))) ;
