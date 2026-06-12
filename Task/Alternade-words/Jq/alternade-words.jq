# if the input is an alternade word relative to the keys of $dict,
# then emit [$even, $odd], else false.
def is_alternade($dict):
  def seconds($start): [.[range($start;length;2)]];
  explode
  | [seconds(0,1)] | map(implode)
  | if $dict[.[0]] and $dict[.[1]] then . else false end;

INDEX( inputs; . )
| . as $dict
| keys_unsorted[]
| select(length>5)
| . as $w
| is_alternade($dict)
| (select(.) // empty)
| "\($w) → \(.[0]) \(.[1])"
