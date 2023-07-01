# Assuming sufficiently-precise integer arithmetic,
# if the input and $j are integers, then the result will be a pair of integers,
# except that if $j is 0, then an error condition is raised.
def divmod($j):
  . as $i
  | ($i % $j) as $mod
  | [($i - $mod) / $j, $mod] ;

# Input may be an object or an array
def swap($i; $j):
  .[$i] as $t
  | .[$i] = .[$j]
  | .[$j] = $t;

def factorial:
  . as $n
  | reduce range(2; $n) as $i ($n; . * $i);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
