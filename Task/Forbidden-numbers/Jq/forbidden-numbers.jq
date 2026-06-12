def count(s): reduce s as $x (0; .+1);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# The def of _nwise can be omitted if using the C implementation of jq:
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def forbidden($max):
  def ub($a;$b):
    if $b < 0 then 0 else [$a, ($b|sqrt)] | min end;

  [false, range(1; 1 + $max)]
  | reduce range(1; 1 + ($max|sqrt)) as $i (.;
      ($i*$i) as $s1
      | .[$s1] = false
      | reduce range(1; 1 + ub($i; ($max - $s1))) as $j (.;
          ($s1 + $j*$j) as $s2
	  | .[$s2] = false
          | reduce range(1; 1 + ub($j; ($max - $s2))) as $k (.;
              .[$s2 + $k*$k] = false ) ) )
  | map( select(.) ) ;

forbidden(500) as $f
| "First fifty forbidden numbers:",
  ( $f[:50] | _nwise(10) | map(lpad(3)) | join(" ") ),
  "\nForbidden number count up to 500: \(count($f[]))",
  ((5000, 50000, 500000) | "\nForbidden number count up to \(.): \(count(forbidden(.)[])) ")
