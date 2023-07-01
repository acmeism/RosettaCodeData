# Generate a stream of subsets of the input array
def subsets:
  if length == 0 then []
  else .[0] as $first
    | (.[1:] | subsets)
    | ., ([$first] + .)
  end ;

# Generate a stream of non-continuous indices in the range 0 <= i < .
def non_continuous_indices:
  [range(0;.)] | subsets
  | select(length > 1 and length != 1 + .[length-1] - .[0]) ;

def non_continuous_subsequences:
  (length | non_continuous_indices) as $ix
  | [.[ $ix[] ]] ;
