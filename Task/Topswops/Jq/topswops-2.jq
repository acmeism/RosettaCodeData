# Input: a permutation; output: an integer
def flips:
  # state: [i, array]
  [0, .]
  | until( .[1][0] == 1;
           .[1] as $p | $p[0] as $p0
	   | [.[0] + 1,  ($p[:$p0] | reverse) + $p[$p0:] ] )
  | .[0];

# input: n, the number of items
def fannkuch:
  reduce permutations as $p
    (0; [., ($p|flips) ] | max);
