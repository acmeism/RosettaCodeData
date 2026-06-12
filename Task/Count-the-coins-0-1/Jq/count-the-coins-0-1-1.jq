# Input: an array of arrays
# Output: a stream of arrays corresponding to the selection of exactly one item
# from each top-level array
def combinations:
  if length == 0 then []
  else
  .[0][] as $x
  | (.[1:] | combinations) as $y
  | [$x] +  $y
  end ;

# Generate a stream of all the permutations of the input array
def permutations:
  if length == 0 then []
  else
    range(0;length) as $i
    | [.[$i]] + (del(.[$i])|permutations)
  end ;
