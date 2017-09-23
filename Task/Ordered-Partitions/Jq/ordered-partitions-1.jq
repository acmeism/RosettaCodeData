# Generate a stream of the distinct combinations of r items taken from the input array.
def combination(r):
  if r > length or r < 0 then empty
  elif r == length then .
  else  ( [.[0]] + (.[1:]|combination(r-1))),
        ( .[1:]|combination(r))
  end;

# Input: a mask, that is, an array of lengths.
# Output: a stream of the distinct partitions defined by the mask.
def partition:

  # partition an array of entities, s, according to a mask presented as input:
  def p(s):
    if length == 0 then []
    else . as $mask
    | (s | combination($mask[0])) as $c
    | [$c] + ($mask[1:] | p(s - $c))
    end;
 . as $mask | p( [range(1; 1 + ($mask|add))] );
