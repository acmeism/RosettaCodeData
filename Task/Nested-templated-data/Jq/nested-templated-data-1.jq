#!/bin/bash
function template {
  cat<<EOF
  [
    [[1, 2],
     [3, 4, 1],
      5 ]]
EOF
}

function payload {
  for i in $(seq 0 6) ; do
    echo Payload#$i
  done
}

# Task 1: Template instantiation
payload | jq -Rn --argfile t <(template) '
  ([inputs] | with_entries(.key |= tostring)) as $dict
  | $t
  | walk(if type == "number" then $dict[tostring] else . end)
'
