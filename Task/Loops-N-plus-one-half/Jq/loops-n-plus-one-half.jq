One approach is to construct the answer incrementally:
def loop_plus_half(m;n):
  if m<n then reduce range(m+1;n) as $i (m|tostring; . +  ", " + ($i|tostring))
  else empty
  end;

# An alternative that is shorter and perhaps closer to the task description because it uses range(m;n) is as follows:
def loop_plus_half2(m;n):
  [range(m;n) | if . == m then . else  ", ", . end | tostring] | join("");
