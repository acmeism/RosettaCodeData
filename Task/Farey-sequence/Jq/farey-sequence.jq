include "rational" ;  # actually, only `r/2` and `gcd/2` are actually needed

# Emit an ordered stream of the Farey sequence of order $order
# by recursively generating the mediants
def FS($order):
  def f($l; $r; $n):
    r($l.n + $r.n; $l.d + $r.d) as $m
    | select($m.d <= $n)
    | f($l; $m; $n), $m, f($m; $r; $n);

  r(0;1) as $l
  | r(1;1) as $r
  | $l, f($l; $r; .), $r;

# Pretty-print Farey sequences of order $min up to and including order $max
def FareySequences($min; $max):
  def rpp: "\(.n)/\(.d)";
  def pp(s): [s|rpp] | join(" ");
  range($min;$max+1)
  | "F(\(.)): " + pp(FS(.));

# Use `count/1` for counting to save space
def count(s): reduce s as $_ (0; .+1);
def FareySequenceMembers($N):
  count(FS($N));

# The tasks:
FareySequences(1;11),
"",
(range(100; 1001; 100) | "F\(.): \(FareySequenceMembers(.)|length) members" )
