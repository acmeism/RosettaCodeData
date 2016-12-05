def until(cond; update):
  def _until:
    if cond then . else (update | _until) end;
  try _until catch if .== "break" then empty else . end;

# binary search for insertion point
def bsearch(target):
  . as $in
  | [0, length-1] # [low, high]
  | until(.[0] > .[1];
          .[0] as $low | .[1] as $high
          | ($low + ($high - $low) / 2 | floor) as $mid
          | if $in[$mid] >= target
            then .[1] = $mid - 1
            else .[0] = $mid + 1
            end )
  | .[0];
