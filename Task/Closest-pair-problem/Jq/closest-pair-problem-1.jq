# This definition of "until" is included in recent versions (> 1.4) of jq
# Emit the first input that satisfied the condition
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;

# Euclidean 2d distance
def dist(x;y):
  [x[0] - y[0], x[1] - y[1]] | map(.*.) | add | sqrt;
