# Input: an array of n elements, each of which is either in or out
# Output: a stream of the 2^n possible selections
def selections:
  # map( [null, .] ) | combinations | map(select(.));
  if length == 0
  then .
  else .[0] as $x
  | .[1:] | selections | ., ([$x] + .)
  end ;

# input: a JSON object giving the weights
def zero_sums:
  def sum($dict; $sum):
    map( $dict[.] ) | add == $sum;

  . as $dict
  | keys_unsorted | selections | select( sum($dict; 0));
