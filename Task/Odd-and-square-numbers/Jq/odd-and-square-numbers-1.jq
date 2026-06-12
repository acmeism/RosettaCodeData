# Output: a stream up to but less than $upper
def oddSquares($upper):
  label $out
  | 1, foreach range(1;infinite) as $i (1;
     . + 8 * $i;
     if . >= $upper then break $out else . end);

oddSquares(1000) | select(. > 100)
