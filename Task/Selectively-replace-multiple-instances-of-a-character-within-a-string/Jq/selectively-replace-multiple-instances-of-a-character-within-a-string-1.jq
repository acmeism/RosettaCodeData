# Emit empty if the stream does not have an $n-th item
# Note: jq's nth/2 does not serve our purposes.
def n_th($n; stream):
  if $n < 0 then empty
  else foreach stream as $x (-1; .+1; if . == $n then $x else empty end)
  end;

def positions(stream; $v):
  foreach stream as $x (-1; .+1; if $v == $x then . else empty end);

# Input: an array or string.
# Output: the input with an occurrence of $old replaced by $new.
# . and $reference are assumed to be of the same type and length.
# The search occurs in $reference and the corresponding spot in . is modified.
def replace_nth($occurrence; $old; $new; $reference):
  if type == "array"
  then ($reference | n_th($occurrence; positions(.[]; $old)) // null) as $ix
  | if $ix then .[:$ix] + [$new] + .[$ix + 1:] else . end
  else explode
  | replace_nth($occurrence; $old|explode|first; $new|explode|first; $reference|explode)
  | implode
  end;
