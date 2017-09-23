# Given an m x n matrix,
# produce a stream of the matrix elements (taken row-wise)
# up to but excluding the first occurrence of $max
def stream($max):
  . as $matrix
  | length as $m
  | (.[0] | length) as $n
  | label $ok
  | {i: range(0;$m), j: range(0;$n)}
  | $matrix[.i][.j] as $m
  | if $m == $max then break $ok else $m end ;
