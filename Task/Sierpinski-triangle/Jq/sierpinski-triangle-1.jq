def elementwise(f):
  transpose | map(f) ;

# input: an array of decimal numbers
def bitwise_and:
  # Input: an integer
  # Output: a stream of 0s and 1s
  def stream:
    recurse(if . > 0 then ./2|floor else empty end) | . % 2 ;

  # Input: a 0-1 array
  def toi:
    reduce .[] as $c ( {power:1 , ans: 0};
      .ans += ($c * .power) | .power *= 2 )
    | .ans;

  if any(.==0) then 0
  else map([stream])
  | (map(length) | min) as $min
  | map( .[:$min] ) | elementwise(min) | toi
  end;
