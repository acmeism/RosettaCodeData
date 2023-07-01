# Generate a stream of the permutations of the input array.
def permutations:
  if length == 0 then []
  else range(0;length) as $i
  | [.[$i]] + (del(.[$i])|permutations)
  end ;

# Generate a stream of arrays of length n,
# with members drawn from the input array.
def take(n):
  length as $l |
  if n == 1 then range(0;$l) as $i | [ .[$i] ]
  else take(n-1) + take(1)
  end;

# Emit an array with elements that alternate between those in the input array and those in short,
# starting with the former, and using nothing if "short" is too too short.
def intersperse(short):
 . as $in
 | reduce range(0;length) as $i
     ([]; . + [ $in[$i], (short[$i] // empty) ]);

# Emit a stream of all the nested triplet groupings of the input array elements,
# e.g. [1,2,3,4,5] =>
# [1,2,[3,4,5]]
# [[1,2,3],4,5]
#
def triples:
  . as $in
  | if   length == 3 then .
    elif length == 1 then $in[0]
    elif length < 3 then empty
    else
      (range(0; (length-1) / 2) * 2 + 1)  as $i
      | ($in[0:$i] | triples)  as $head
      | ($in[$i+1:] | triples) as $tail
      | [$head, $in[$i], $tail]
    end;
