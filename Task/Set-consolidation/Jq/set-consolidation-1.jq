def to_set: unique;

def union(A; B): (A + B) | unique;

# boolean
def intersect(A;B):
  reduce A[] as $x (false; if . then . else (B|index($x)) end) | not | not;
