# stringset_difference: A \ B
def stringset_difference(A;B):
  reduce (A|keys)[] as $k
    ({}; if (B|has($k)) then . else . + {($k):true} end);
