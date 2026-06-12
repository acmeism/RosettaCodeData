include "elementary-cellular-automaton" {search : "."};  # the defs at [[Elementary_cellular_automaton#jq]]

def binary2number:
  reduce (.[]|tonumber) as $x ({p:1}; .n += .p * $x | .p *= 2) | .n;

# Emit a stream of $n PRNGs in range(0;255)
def prng($n):
  # 30 is 11110
  ("1" + 100 * "0" )
  | [automaton(30; 8 * $n) | .[0:1]]
  | _nwise(8) | binary2number ;

foreach prng(99*99) as $color ({x:0, y:1};
  .color = $color
  | .x += 1
  | if .x == 100 then .x = 1 | .y += 1 else . end )
  | "\(.x) \(.y) \(.color)"
