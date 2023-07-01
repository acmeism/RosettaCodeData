# Input: an array
# If the rightmost element, .[-1], does not occur elsewhere, return 0;
# otherwise return the "depth" of its rightmost occurrence in .[0:-2]
def depth:
  .[-1] as $x
  | length as $length
  | first(range($length-2; -1; -1) as $i
          | select(.[$i] == $x) | $length - 1 - $i)
     // 0 ;

# Generate a stream of the first $n van Eck integers:
def vanEck($n):
  def v:
    recurse( if length == $n then empty
             else . + [depth] end );
  [0] | v | .[-1];

# The task:
[vanEck(10)], [vanEck(1000)][990:1001]
