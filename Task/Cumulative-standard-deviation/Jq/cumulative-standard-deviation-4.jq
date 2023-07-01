#!/bin/bash

# jq is assumed to be on PATH

PROGRAM='
def standard_deviation: .ssd / .n | sqrt;

def update_state(observation):
  def sq: .*.;
  ((.mean * .n + observation) / (.n + 1)) as $newmean
  | (.ssd + .n * ((.mean - $newmean) | sq)) as $ssd
  | { "n": (.n + 1),
      "ssd":  ($ssd + ((observation - $newmean) | sq)),
      "mean": $newmean }
;

def initial_state: { "n": 0, "ssd": 0, "mean": 0 };

# Input should be [observation, null] or [observation, state]
def standard_deviations:
  . as $in
  | if type == "array" then
      (if .[1] == null then initial_state else .[1] end) as $state
      | $state | update_state($in[0])
      | standard_deviation, .
    else empty
    end
;

standard_deviations
'
state=null
while read -p "Next observation: " observation
do
  result=$(echo "[ $observation, $state ]" | jq -c "$PROGRAM")
  sed -n 1p <<< "$result"
  state=$(sed -n 2p <<< "$result")
done
