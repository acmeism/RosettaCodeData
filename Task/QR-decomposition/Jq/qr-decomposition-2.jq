def minor($x; $d):
   ($x|length) as $nr
   | ($x[0]|length) as $nc
   | reduce range(0; $d) as $i (matrix($nr;$nc;0); .[$i][$i] = 1)
   | reduce range($d; $nr) as $i (.;
       reduce range($d;$nc) as $j (.; .[$i][$j] = $x[$i][$j] ) );

def vmadd($a; $b; $s):
  reduce range (0; $a|length) as $i ([];
    .[$i] = $a[$i] + $s * $b[$i] );

def vmul($v):
  ($v|length) as $n
  | reduce range(0;$n) as $i (null;
      reduce range(0;$n) as $j (.; .[$i][$j] = -2 * $v[$i] * $v[$j] ))
  | reduce range(0;$n) as $i (.; .[$i][$i] += 1 );

def vnorm($x):
  sum($x[] | .*.) | sqrt;

def vdiv($x; $d):
  [range (0;$x|length) | $x[.] / $d];

def mcol($m; $c):
  [range (0;$m|length) | $m[.][$c]];

def householder($m):
    ($m|length) as $nr
    | ($m[0]|length) as $nc
    | { q: [], # $nr
        z: $m,
        k: 0 }
    | until( .k >= $nc or .k >= $nr-1;
        .z = minor(.z; .k)
        | .x = mcol(.z; .k)
        | .a = vnorm(.x)
        | if ($m[.k][.k] > 0) then .a = -.a else . end
        | .e = [range (0; $nr) as $i | if ($i == .k) then 1 else 0 end]
        | .e = vmadd(.x; .e; .a)
        | .e = vdiv(.e; vnorm(.e))
        | .q[.k] = vmul(.e)
        | .z = multiply(.q[.k]; .z)
        | .k += 1 )
    | .Q = .q[0]
    | .R = multiply(.q[0]; $m)
    | .i = 1
    | until (.i >= $nc or .i >= $nr-1;
        .Q = multiply(.q[.i]; .Q)
        | .i += 1 )
    | .R = multiply(.Q; $m)
    | .Q |= transpose
    | [.Q, .R] ;

def x: [
  [12, -51,   4],
  [ 6, 167, -68],
  [-4,  24, -41],
  [-1,   1,   0],
  [ 2,   0,   3]
];

def task:
  def pp: pp(3;8);

  # Assume $a and $b are conformal
  def ssd($a; $b):
    [$a[][]] as $a
    | [$b[][]] as $b
    | ss( range(0;$a|length) | $a[.] - $b[.] );

  householder(x) as [$Q, $R]
  | multiply($Q; $R) as $m
  | "Q:",      ($Q|pp),
   "\nR:",     ($R|pp),
   "\nQ * R:", ($m|pp),
   "\nSum of squared discrepancies: \(ssd(x; $m))"
;

task
