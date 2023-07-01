# Generate a stream of all the permutations of the input array
def permutations:
  if length == 0 then []
  else
    range(0;length) as $i
    | [.[$i]] + (del(.[$i])|permutations)
  end ;

# Permutations of a ... n inclusive
def permutations(a;n):
  [range(a;n+1)] | permutations;

# value of a box
# Input: the table of values
def valueOfBox($box):
  [ .[ $box[] ]] | add;

def allEqual($boxes):
  . as $values
  | valueOfBox($boxes[0]) as $sum
  | all($boxes[1:][]; . as $box | $values | valueOfBox($box) == $sum);

def combinations($m; $n; $size):
  [range(0; $size) | [range($m; $n)]] | combinations;

def count(s): reduce s as $x (null; .+1);

# a=0, b=1, etc
def boxes: [[0,1], [1,2,3], [3,4,5], [5,6]];

def tasks:
  "1 to 7:",
  (permutations(1;7) | select(allEqual(boxes))),
  "\n3 to 9:",
  (permutations(3;9) | select(allEqual(boxes))),
  "\n0 to 9:\n\(count(permutations(0;9) | select(allEqual(boxes))))",
  "\nThere are \(count(combinations(0;10;7) | select(allEqual(boxes)))) solutions for 0 to 9 with replacement."
;

tasks
