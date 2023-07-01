include "rc-modular-exponentiation";  # see remark above

# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

def Solution(a;b;c):
  {"root1": a, "root2": b, "exists": c};

# pretty print a Solution
def pp:
  if .exists
  then "root1 = \(.root1)",
       "root2 = \(.root2)"
  else "No solution exists"
  end;

# Tonelli-Shanks
def ts($n; $p):
    def powModP($a; $e): $a | modPow($e; $p);

    def ls($a): powModP($a; ($p - 1) | idivide(2));

    if ls($n) != 1 then Solution(0; 0; false)
    else { q: ($p - 1), ss: 0}
    | until (.q % 2 != 0;
        .ss += 1
        | .q |= idivide(2) )
    | if .ss == 1
      then powModP(n; ($p+1) | idivide(4)) as $r1
      | Solution($r1; $p - $r1; true)
      else .z = 2
      | until ( ls(.z) == ($p - 1); .z += 1 )
      | .c = powModP(.z; .q)
      | .r = powModP($n; (.q+1) | idivide(2))
      | .t = powModP($n; .q)
      | .m = .ss
      | until (.emit;
          if .t == 1 then .emit = Solution(.r; $p - .r; true)
          else .i = 0
          | .zz = .t
          | until (.zz == 1 or .i >= (.m - 1);
              .zz = (.zz * .zz) % p
              | .i += 1 )
          | .b = .c
          | .e = .m - (1 + .i)
          | until (.e <= 0;
              .b = (.b * .b) % $p
              | .e += -1 )
          | .r = (.r * .b) % $p
          | .c = (.b * .b) % $p
          | .t = (.t * .c) % $p
          | .m = .i
	  end )
      | .emit
      end
    end;

def pairs: [
    [10, 13], [56, 101], [1030, 10009], [1032, 10009], [44402, 100049],
    [665820697, 1000000009], [881398088036, 1000000000039]
];

def task:
  pairs[] as [$n, $p]
  | ts($n; $p) as $sol
  | "n     = \($n)",
    "p     = \($p)",
    ($sol | pp),
    "";

def task2:
  def bn: 41660815127637347468140745042827704103445750172002;
  def bp: (10 | power(50)) + 577;
  ts(bn; bp) as $bsol
  | "n     = \(bn)",
    "p     = \(bp)",
    ( $bsol | pp );

task, task2
