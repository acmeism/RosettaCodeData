# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

# Output: {n, heads, wakings}
def sleepingBeauty:
  { n: ., wakings: 0, heads: 0 }
  | reduce range(0; .n) as $i (.;
      (2|prn) as $coin # heads = 0, tails = 1 say
      | .wakings += 1
      | if $coin == 0 then .heads += 1
        else .wakings += 1
        end );

1000000
| sleepingBeauty
| "Wakings over \(.n) repetitions = \(.wakings).",
  "Percentage probability of heads on waking = \(100*.heads/.wakings | round(3))%"
