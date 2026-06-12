# Given an array of counts of the nonnegative integers, produce an array reflecting the multiplicities:
# e.g. [3,1] => [0,0,0,1]
def items:
  . as $in
  | reduce range(0;length) as $i ([]; . + [range(0;$in[$i])|$i]);

# distinct permutations of the input array, via insertion
def distinct_permutations:
  # Given an array as input, generate a stream by inserting $x at different positions to the left
  def insert($x):
     ((index([$x]) // length) + 1) as $ix
     | range(0; $ix) as $pos
     | .[0:$pos] + [$x] + .[$pos:];

  if length <= 1 then .
  else
    .[0] as $first
    | .[1:] | distinct_permutations | insert($first)
  end;
