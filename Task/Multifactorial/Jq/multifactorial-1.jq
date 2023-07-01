# Input: n
# Output: n * (n - d) * (n - 2d) ...
def multifactorial(d):
  . as $n
  | ($n / d | floor) as $k
  | reduce ($n - (d * range(0; $k))) as $i (1; . * $i);
