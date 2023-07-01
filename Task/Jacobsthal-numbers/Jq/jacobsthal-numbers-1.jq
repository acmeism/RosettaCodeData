# Split the input array into a stream of arrays
def chunks(n):
  def c: .[0:n], (if length > n then .[n:]|c else empty end);
  c;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be a pair of integers.
def divmod($j):
  . as $i
  | ($i % $j) as $mod
  | [($i - $mod) / $j, $mod] ;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);
