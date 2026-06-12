# Input: an array, $in, of 0 or more arrays
# Output: a stream of arrays, c, with c[i] drawn from $in[i].
def combinations:
  if length == 0 then []
  else
  .[0][] as $x
  | (.[1:] | combinations) as $y
  | [$x] +  $y
  end ;

# Input: an array of the k values from which to choose.
# Output: a stream of arrays of length n with elements drawn from the input array.
def permutations_with_replacements(n):
  . as $in | [range(0; n) | $in] | combinations;
