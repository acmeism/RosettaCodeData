# Emit a stream of words "greater than" the input word that differ by just one character.
def changeable_to($dict):
  . as $w
  | range(0;length) as $i
  | (.[$i:$i+1]|explode[]) as $j
  | [range($j+1;123) | [.] | implode] as $alphas  # 122 is "z"
  | .[:$i] + $alphas[] + .[$i+1:]
  | select($dict[.]);

INDEX( inputs; . )
| . as $dict
| keys_unsorted[] # or keys[] for gojq
| select(length>11)
| . as $w
| [changeable_to($dict)] | unique[]
| "\($w) <=> \(.)"
