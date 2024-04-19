# Require $n > 0
def nwise($n):
  def _n: if length <= $n then . else .[:$n] , (.[$n:] | _n) end;
  if $n <= 0 then "nwise: argument should be non-negative" else _n end;

### Part 1 - generic functions

# Ensure $x is in the input sorted array
def ensure($x):
  bsearch($x) as $i
  | if $i >= 0 then .
    else (-1-$i) as $i
    | .[:$i] + [$x] + .[$i:]
    end ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def table($wide; $pad):
   nwise($wide) | map(lpad($pad)) | join(" ");

def count(s): reduce s as $x (0; .+1);

def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# jq optimizes the recursive call of _gcd in the following:
def gcd($a;$b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [$a,$b] | _gcd ;

def totient:
  . as $n
  | count( range(0; .) | select( gcd($n; .) == 1) );

# Emit a sorted array
def getPerfectPowers( $maxExp ):
  (10 | power($maxExp)) as $upper
  | reduce range( 2; 1 + ($upper|sqrt|floor)) as $i ({pps: []};
     .p = $i * $i
     | until (.p >= $upper;
         .pps += [ .p ]
         | .p *= $i) )
  | .pps
  | sort;

# Input: a sufficiently long array of perfect powers in order
def getAchilles($minExp; $maxExp):
  def cbrt: pow(.; 1/3);
  . as $pps
  | (10 | power($minExp)) as $lower
  | (10 | power($maxExp)) as $upper
  | ($upper | sqrt | floor) as $sqrtupper
  | reduce range(1; 1 + ($upper|cbrt|floor)) as $b ({achilles: []};
        ($b | .*.*.) as $b3
        | .done = false
        | .a = 1
        | until(.done or (.a > $sqrtupper);
            ($b3 * .a * .a) as $p
            | if $p >= $upper then .done = true
              elif $p >= $lower and ($pps | bsearch($p) < 0)
              then .achilles |= ensure($p)
              end
            | .a += 1 ) )
  | .achilles;

def task($maxDigits):
  getPerfectPowers($maxDigits)
  | . as $perfectPowers
  | getAchilles(1; 5)
  | . as $achilles
  | "First 50 Achilles numbers:",
     (.[:50] | table(10;5)),
     "\nFirst 30 strong Achilles numbers:",
     ({ strongAchilles:[], count:0, n:0 }
     | until (.count >= 30;
         $achilles[.n] as $a
         | ($a | totient) as $tot
         | if ($achilles | bsearch($tot)) >= 0
           then .strongAchilles |= ensure($a)
           | .count += 1
           end
           | .n += 1 )
     | (.strongAchilles | table(10;5) ),
     "\nNumber of Achilles numbers with:",
     ( range(2; 1+$maxDigits) as $d
       | ($perfectPowers|getAchilles($d-1; $d)|length) as $ac
       | "\($d) digits: \($ac)" ) )
;

task(10)
