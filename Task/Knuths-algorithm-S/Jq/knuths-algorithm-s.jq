# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# Input and output: {n, s, next, m}
# The initial input should be
# {n: $n, s: [range(0;$n)|0], next: 0, m: $n}
# where $n is the maximum sample size.
def sOfN(items):
  if (.next < .n)
  then .s[.next] = items
  | .next += 1
  else .m += 1
  | if ((.m | prn) < .n)
    then (.n | prn) as $t
    | .s[$t] = items
    | if .next <= $t
      then .next = $t + 1
      else .
      end
    else .
    end
  end;

def task($iterations):
  def dim($n): [range(0;$n)|0];
  def init($n): {n: $n, s: dim($n), next: 0, m: $n };

  reduce range(0; $iterations) as $r ( {freq: dim(10) };
    reduce range(48; 57) as $d (. + init(3); sOfN($d) )
    | reduce sOfN(57).s[] as $d (.;
        .freq[$d - 48] += 1) )
  | .freq ;

task(1e5)
