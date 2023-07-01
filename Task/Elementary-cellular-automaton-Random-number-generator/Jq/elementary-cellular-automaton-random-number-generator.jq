include "elementary-cellular-automaton" {search : "."};

# If using jq, the def of _nwise can be omitted.
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# Input: an array of bits represented by 0s, 1s, "0"s, or "1"s
# Output: the corresponding decimal on the assumption that the leading bits are least significant,
# e.g. [0,1] => 2
def binary2number:
  reduce (.[]|tonumber) as $x ({p:1}; .n += .p * $x | .p *= 2) | .n;

("1" + 100 * "0" ) | [automaton(30; 80) | .[0:1]] | [_nwise(8) | reverse | binary2number]
