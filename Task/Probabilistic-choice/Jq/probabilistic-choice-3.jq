# Given that $integers is an array of integers to be interpreted as
# relative probabilities, return a corresponding element chosen
# randomly from the input array.
def randomly($integers):
  def accumulate: reduce .[1:][] as $i ([.[0]]; . + [$i + .[-1]]);
  if ($integers | length) != length
  then "randomly/1: the array lengths are unequal" | error
  else . as $in
  | $integers
  | add as $sum
  | accumulate as $p
  | ($sum|prn + 1) as $random
  | $in[first(range(0; $p|length) | select( $random <= $p[.] ))]
  end ;

# Input should be a JSON object giving probabilities of each key as a rational: {n, d}
def choose($n):
  lcm(.[].d) as $lcm
  | ([.[] | $lcm * .n / .d]) as $p
  | keys_unsorted as $items
  | range(0; $n)
  | $items | randomly($p);

# Print a table comparing expected, observed and the ratio
# (expected - observed)^2 / expected
def compare( $expected; $observed ):
  def p($n): align_decimal($n) | lpad(8);

  "       : expected observed  (e-o)^2 / e",
   ( $expected
   | keys_unsorted[] as $k
   | .[$k] as $e
   | ($observed[$k] // 0) as $o
   | "\($k|lpad(6)) : \($e|p(1)) \($o|floor|lpad(8)) \( (($e - $o) | (.*.) / $e) | p(2))" );

# The specific task
def probabilities:
{ "aleph":   r(1; 5),
  "beth":    r(1; 6),
  "gimel":   r(1; 7),
  "daleth":  r(1; 8),
  "he":      r(1; 9),
  "waw":     r(1; 10),
  "zayin":   r(1; 11),
  "heth":    r(1759; 27720)
};

def task($n):
  probabilities
  | bow(choose($n)) as $observed
  | compare( map_values($n * .n / .d); $observed ) ;

task(1E6)
'
