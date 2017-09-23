# Input:  [i, [0^i, 1^i, 2^i, ..., 9^i]]
# Output: [j, [0^j, 1^j, 2^j, ..., 9^j]]
# provided j is i or (i+1)
def powers(j):
  if .[0] == j then .
  else .[0] += 1
  | reduce range(0;10) as $k (.; .[1][$k] *= $k)
  end;
