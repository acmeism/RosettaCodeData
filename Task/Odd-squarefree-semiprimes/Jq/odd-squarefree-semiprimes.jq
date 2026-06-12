# Output: a stream of proper square-free odd prime factors of .
def proper_odd_squarefree_prime_factors:
  range(3; 1 + sqrt|floor) as $i
  | select( (. % $i) == 0 )
  | (. / $i) as $r
  | select($i != $r and all($i, $r; is_prime) )
  | $i, $r;

def is_odd_squarefree_semiprime:
  isempty(proper_odd_squarefree_prime_factors) | not;

# For pretty-printing
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# The task:
[range(3;1000;2)
 | select(is_odd_squarefree_semiprime)]
| nwise(10)
| map(lpad(3)) | join(" ")
