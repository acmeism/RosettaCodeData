def amb(condition): .[] | select(condition);

def joins:
  (.[0][-1:]) as $left
  | (.[1][0:1]) as $right
  | $left == $right ;
