### Utility Functions
# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def round: ((. * 100) | floor) / 100;

# input: n
# output: boolean, such that P(true) == 1/n
def biased:
  prn == 1 | debug;

def unbiased:
  . as $n
  | {}
  | until( .a != .b; {a: ($n|biased), b: ($n|biased)})
  | .a;

def task($m):
  def f(x;y;z): "\(x): \(y|round)%  \(z|round)%";

  range(3;7) as $n
  | reduce range(0; $m) as $i ( {c1:0, c2:0};
        if ($n|biased)   then .c1 += 1 else . end
      | if ($n|unbiased) then .c2 += 1 else . end)
  | f($n; 100 * .c1 / $m; 100 * .c2 / $m);

task(50000)
