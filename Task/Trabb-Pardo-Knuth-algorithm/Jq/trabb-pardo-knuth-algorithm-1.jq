def f:
  def abs: if . < 0 then -. else . end;
  def power(x): (x * log) | exp;
  . as $x | abs | power(0.5) + (5 * (.*.*. ));

. as $in | split(" ") | map(tonumber)
| if length == 11 then
    reverse | map(f | if . > 400 then "TOO LARGE" else . end)
  else error("The number of numbers was not 11.")
  end
| .[]  # print one result per line
