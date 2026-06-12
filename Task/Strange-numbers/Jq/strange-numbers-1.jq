def is_strange:
  def digits: tostring | explode | map([.] | implode | tonumber);
  digits
  | . as $d
  | [2, 3, 5, 7] as $primes
  | all( range(1; length);
         ($d[.] - $d[. - 1]) | length | IN( $primes[]));

# Pretty-printing
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($start; $stop; filter):
  "Finding numbers matching $f for open interval \($start), \($stop):\n",
  ( [range($start; $stop) | select(filter) ]
    | nwise(10) | map(lpad(3)) | join(" ") );

task(100; 500; is_strange)
