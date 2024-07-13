# The input should be a JSON object with a key named "period".
# The output is a JSON object with a key named "average" giving the SMA.
def sma($x):
  def average:
    .n as $n
    | if $n == null or $n == 0 then . + {n: 1, average: $x}
      else .average |= (. * $n + $x) / ($n + 1)
      | .n += 1
      end;

  if . == null or (.period and .period < 1)
  then "The initial call to sma/1 must specify the period properly" | error
  elif .n and .n < 0 then "Invalid value of .n" | error
  elif (.period | isinfinite) then average
  elif .n == null or .n == 0 then . + {n: 1, average: $x, array: [$x]}
  else .n as $n
  | if $n < .period
    then .array += [$x]
    | .n += 1
    else .array |= .[1:] + [$x]
    end
  | .average = (.array | (add/length))
  end;

# Call sma($x) for the 11 numbers 0, 1, ... 10.
def example($period):
 reduce range(0;11) as $x({period: $period}; sma($x))
 | .average ;

example(11), example(infinite)
