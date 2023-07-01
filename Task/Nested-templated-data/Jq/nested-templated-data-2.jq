payload | jq -Rn --argfile t <(template) '
  ([inputs] | with_entries(.key |= tostring)) as $dict
  | $dict[(($dict|keys_unsorted) - ([ $t | .. | numbers ] | unique | map(tostring) ))[]]
'
