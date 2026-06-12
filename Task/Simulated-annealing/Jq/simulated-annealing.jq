## Pseuo-random numbers and shuffling

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def randFloat:
   (1000|prn) / 1000;

def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;


## Generic utilities
def divmod($j):
  (. % $j) as $mod
  | [(. - $mod) / $j, $mod] ;

def hypot($a;$b):
  ($a*$a) + ($b*$b) | sqrt;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

def sum(s): reduce s as $x (0; . + $x);

def swap($i; $j):
  .[$i] as $tmp
  | .[$i] = .[$j]
  | .[$j] = $tmp;


### The cities

# all 8 neighbors for an $n x $n grid
def neighbors($n): [1, -1, $n, -$n, $n-1, $n+1, -$n-1, $n+1];

# Distance between two cities $x and $y in an .n * .n grid
def dist($x; $y):
  .n as $n
  | ($x | divmod($n)) as [$xi, $xj]
  | ($y | divmod($n)) as [$yi, $yj]
  | hypot( $xi-$yi; $xj - $yj );


### Simulated annealing

# The energy of the input state (.s), to be minimized
# Input: {s, n}
def Es:
  .s as $path
  | sum( range(0; $path|length - 1) as $i
         | dist($path[$i]; $path[$i+1]) );

# temperature function, decreases to 0
def T($k; $kmax; $kT):
  (1 - ($k / $kmax)) * $kT;

# variation of E, from one state to the next state
# Input: {s, n}
def dE($u; $v):
  .s as $s
  | $s[$u] as $su
  | $s[$v] as $sv
  # old
  | dist($s[$u-1]; $su) as $a
  | dist($s[$u+1]; $su) as $b
  | dist($s[$v-1]; $sv) as $c
  | dist($s[$v+1]; $sv) as $d
  # new
  | dist($s[$u-1]; $sv) as $na
  | dist($s[$u+1]; $sv) as $nb
  | dist($s[$v-1]; $su) as $nc
  | dist($s[$v+1]; $su) as $nd
  | if ($v == $u+1) then ($na + $nd) - ($a + $d)
    elif ($u == $v+1) then ($nc + $nb) - ($c + $b)
    else ($na + $nb + $nc + $nd) - ($a + $b + $c + $d)
    end;

# probability of moving from one state to another
def P($deltaE; $k; $kmax; $kT):
  T($k; $kmax; $kT) as $T
  | if $T == 0 then 0
    else (-$deltaE / $T) | exp
    end;

# Simulated annealing for $n x $n cities
def sa($kmax; $kT; $n):
  def format($k; $T; $E):
    [ "k:", ($k | lpad(10)),
      "T:", ($T | round(2) | lpad(4)),
      "Es:", $E ]
    | join(" ");

  neighbors($n) as $neighbors                      # potential neighbors
  | ($n*$n) as $n2
  # random path from 0 to 0
  | {s: ([0] + ([ range(1; $n2)] | knuthShuffle) + [0]) }
  | .n = $n                                        # for dist/2
  | .Emin = Es                                     # E0
  | "kT = \($kT)",
    "E(s0) \(.Emin)\n",
    ( foreach range(0; 1+$kmax) as $k (.;
          .emit = null
          | if ($k % (($kmax/10)|floor)) == 0
            then .emit = format($k; T($k; $kmax; $kT); Es)
            else .
            end
          | (($n2-1)|prn + 1) as $u                # a random city apart from the starting point
          | (.s[$u] + $neighbors[8|prn]) as $cv    # a neighboring city, perhaps
          | if ($cv <= 0 or $cv >= $n2)            # check the city is not bogus
            then .  # continue
            elif dist(.s[$u]; $cv)  > 5            # check true neighbor
            then .  # continue
            else .s[$cv] as $v                     # city index
            | dE($u; $v) as $deltae
            | if ($deltae < 0 or                   # always move if negative
                  P($deltae; $k; $kmax; $kT) >= randFloat)
              then .s |= swap($u; $v)
              | .Emin += $deltae
              end
            end;

          select(.emit).emit,
          (select($k == $kmax)
           | "\nE(s_final) \(.Emin)",
               "Path:",
                # output final state
                (.s | map(lpad(3)) | _nwise(10) | join(" ")) ) ));

# Cities on a 10 x 10 grid
sa(1e6; 1; 10)
