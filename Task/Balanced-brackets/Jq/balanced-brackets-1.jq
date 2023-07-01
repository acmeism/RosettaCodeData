< /dev/random tr -cd '0-9' | fold -w 1 | jq -Mcnr '

# Output: a PRN in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def prb: 2 | prn == 0;

def balanced:
  {array: explode, parity: 0}
  | until( .result | type == "boolean";
      if .array == [] then .result = (.parity == 0)
      else .parity += (.array[0] | if . == 91 then 1 else -1 end)
      | if .parity < 0 then .result = false
        else .array |= .[1:]
        end
      end ).result ;

def task($n):
  if $n%2 == 1 then null
  else  [ (range(0; $n) | if prb then "[" else "]" end)  // ""]
  | add
  | "\(.): \(balanced)"
  end;

task(0),
task(2),
(range(0;10) | task(4))
