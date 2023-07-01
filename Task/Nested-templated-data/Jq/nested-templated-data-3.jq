payload | jq -Rrn --argfile t <(template) '
  ([inputs] | with_entries(.key |= tostring)) as $dict
  | $t
  | walk(if type == "number" then $dict[tostring] else . end),
    "\nUnused payload",
    $dict[(($dict|keys_unsorted) - ([ $t | .. | numbers ] | unique | map(tostring) ))[]]
'
