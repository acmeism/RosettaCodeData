# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# Emit a stream of [value, frequency] pairs
def histogram(stream):
  reduce stream as $s ({};
    ($s|type) as $t
     | (if $t == "string" then $s else ($s|tojson) end) as $y
     | .[$t][$y][0] = $s
     | .[$t][$y][1] += 1 )
  | .[][] ;

# sum of squares
def ss(s): reduce s as $x (0; . + ($x * $x));

def chiSquared($expected):
  debug # show the actual frequencies
  | ss( .[] - $expected ) / $expected;

# The high-entropy 5-sided die
def dice5: 1 + (5|prn);

# The low-entropy 5-sided die
def pseudo_dice5:
  def r: (now * 100000 | floor) % 10;
  null | until(. and (. < 5); r) | 1 + . ;

# The formal argument dice5 should behave like a 5-sided dice:
def dice7(dice5):
  1 +  ([limit(7; repeat(dice5))]|add % 7) ;

# Issue a report on the results of a sequence of $n trials using the specified dice
def report(dice; $n):
 1.69 as $lower
 | 16.013 as $upper
 | [histogram( limit($n; repeat(dice)) ) | last]
 | chiSquared($n/7) as $x2
 | "The χ2 statistic for a trial of \($n) virtual tosses is \($x2).",
   "Using a two-sided χ2-test with seven degrees of freedom (\($lower), \($upper)), it is reasonable to conclude that",
   (if   $x2 < $lower then "this is lower than would be expected for a fair die."
    elif $x2 > $upper then "this is higher than would be expected for a fair die."
    else "this is consistent with the die being fair."
    end) ;

def report($n):
  "Low-entropy die results:",
  report(dice7(pseudo_dice5); $n),
  "",
  "High-entropy die results:",
  report(dice7(dice5); $n) ;

report(70)
