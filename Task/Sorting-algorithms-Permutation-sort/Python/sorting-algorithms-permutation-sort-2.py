from itertools import permutations
from more_itertools import windowed

def is_sorted(seq):
  return all(
    v1 <= v2
    for v1, v2 in windowed(seq, 2)
  )

def permutation_sort(seq):
  return next(
    permutation
    for permutation in permutations(seq)
    if is_sorted(permutation)
  )
