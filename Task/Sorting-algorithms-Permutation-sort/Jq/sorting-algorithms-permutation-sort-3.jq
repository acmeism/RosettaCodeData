def permutation_sort_slow:
  reduce permutations as $p (null; if . then . elif ($p | sorted) then $p else . end);
