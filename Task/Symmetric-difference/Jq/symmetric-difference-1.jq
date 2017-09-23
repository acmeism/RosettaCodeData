# The following implementation of intersection (but not symmetric_difference) assumes that the
# elements of a (and of b) are unique and do not include null:
def intersection(a; b):
  reduce ((a + b) | sort)[] as $i
    ([null, []]; if .[0] == $i then [null, .[1] + [$i]] else [$i, .[1]] end)
  | .[1] ;

def symmetric_difference(a;b):
  (a|unique) as $a | (b|unique) as $b
  | (($a + $b) | unique) - (intersection($a;$b));
