# Assumption: input consists of random three-digit numbers i.e. 000 to 999
def rand: input;

def set: "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";

def abs:
  if . < 0 then -. else . end;

def ichar:
  if type == "number" then . else explode[0] end;

# Output: a pseudo-random character from set.
# $n should be a random number drawn from range(0; N) inclusive where N > set|length
# Input: an admissible character from `set` (ignored in this implementation)
def shift($n):
  ($n % (set|length)) as $i
  | set[$i:$i+1];

# fitness: 0 indicates a perfect fit; greater numbers indicate worse fit.
def fitness($gold):
  def diff($c; $d): ($c|ichar) - ($d|ichar) | abs;
  . as $in
  | reduce range(0;length) as $i (0; . + diff($in[$i:$i+1]; $gold[$i:$i+1]));

# Input: a string
# Output: a mutation of . such that each character is mutated with probability $r
def mutate($r):
  # Output: a pseudo-random character from set
  # $n should be a random number drawn from range(0; N) inclusive where N > set|length
  def letter($n):
    ($n % (set|length)) as $i
    | set[$i:$i+1];

  . as $p
  | reduce range(0;length) as $i ("";
      rand as $rand
      | if ($rand/1000) < $r then . + letter($rand)
        else . + $p[$i:$i+1]
        end );

# An array of $n children of the parent provided as input; $r is the mutation probability
def children($n; $r):
  [range(0;$n) as $i | mutate($r)];

# Input: a "parent"
# Output: a single string
def next_generation($gold; $r):
  ([.] + children(100; $r))
  | min_by( fitness($gold) );

# Evolve towards the target string provided as input, using $r as the mutation rate;
# `recurse` is used in order to show progress conveniently.
def evolve($r):
  . as $gold
  | (set|length) as $s
  | (reduce range(0; $n) as $i (""; (rand % $s) as $j | . + set[$j:$j+1])) as $string
  | {count: 0, $string }
  | recurse (
      if .string | fitness($gold) == 0 then empty
      else .string |= next_generation($gold; $r)
      | .count += 1
      end);

"METHINKS IT IS LIKE A WEASEL" | evolve(0.05)
