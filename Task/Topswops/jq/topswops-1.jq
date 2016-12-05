# "while" as defined here is included in recent versions (>1.4) of jq:
def until(cond; next):
  def _until:
    if cond then . else (next|_until) end;
  _until;

# Generate a stream of permutations of [1, ... n].
# This implementation uses arity-0 filters for speed.
def permutations:
  # Given a single array, insert generates a stream by inserting (length+1) at different positions
  def insert: # state: [m, array]
     .[0] as $m | (1+(.[1]|length)) as $n
     | .[1]
     | if $m >= 0 then (.[0:$m] + [$n] + .[$m:]), ([$m-1, .] | insert) else empty end;

  if .==0 then []
  elif . == 1 then [1]
  else
    . as $n | ($n-1) | permutations | [$n-1, .] | insert
  end;
