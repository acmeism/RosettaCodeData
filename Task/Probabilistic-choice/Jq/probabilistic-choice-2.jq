# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# General Utility Functions

# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# left pad with blank
def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# right-pad with 0
def rpad($len): tostring | ($len - length) as $l | .+ ("0" * $l)[:$l];

# Input: a string of digits with up to one "."
# Output: the corresponding string representation with exactly $n decimal digits
def align_decimal($n):
  tostring
  | index(".") as $ix
  | if $ix then capture("(?<i>[0-9]*[.])(?<j>[0-9]{0," + ($n|tostring) + "})") as {$i, $j}
    | $i + ($j|rpad($n))
    else . + "." + ("0" * $n)
    end ;

# Input: a string of digits with up to one embedded "."
# Output: the corresponding string representation with up to $n decimal digits but aligned at the period
def align_decimal($n):
  tostring
  | index(".") as $ix
  | if $ix then capture("(?<i>[0-9]*[.])(?<j>[0-9]{0," + ($n|tostring) + "})") as {$i, $j}
    | $i + ($j|rpad($n))
    else . + ".0" | align_decimal($n)
    end ;

# least common multiple
# Define the helper function to take advantage of jq tail-recursion optimization
def lcm($m; $n):
  def _lcm:
    # state is [m, n, i]
    if (.[2] % .[1]) == 0 then .[2]
    else .[0:2] + [.[2] + $m] | _lcm
    end;
  [m, n, m] | _lcm;

def lcm(s): reduce s as $_ (1; lcm(.; $_));
			
# rationals
def r($n; $d): {$n, $d};
