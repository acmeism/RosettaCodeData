# Set-intersection: A ∩ B
def stringset_intersection(A;B):
  reduce (A|keys)[] as $k
    ({}; if (B|has($k)) then . + {($k):true} else . end);
