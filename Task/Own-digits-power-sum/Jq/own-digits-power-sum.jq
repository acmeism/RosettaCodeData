def maxBase: 10;

# The global object:
# { usedDigits, powerDgt, numbers }

def initPowerDgt:
  reduce range(0; maxBase) as $i (null; .[$i] = [range(0;maxBase)|0])
  | reduce range(1; maxBase) as $i (.; .[0][$i] = 1)
  | reduce range(1; maxBase) as $j (.;
        reduce range(0; maxBase) as $i (.;
            .[$j][$i] = .[$j-1][$i]  * $i )) ;

# Input:  global object
# Output: .numbers
def calcNum($depth):
  if $depth < 3 then .
  else .usedDigits as $used
  | .powerDgt as $powerDgt
  | (reduce range(1; maxBase) as $i (0;
        if $used[$i] > 0 then . + $used[$i] * $powerDgt[$depth][$i]
	else . end )) as $result
  | if $result == 0 then .
    else {n: $result, $used, $depth, numbers, r: null}
    | until (.r == 0;
          .r = ((.n / maxBase) | floor)
          | .used[.n - .r * maxBase] += -1
          | .n = .r
          | .depth += -1 )
    | if .depth != 0 then .
      else . + {i: 1}
      | until( .i >= maxBase or .used[.i] != 0; .i += 1)
      | if .i >= maxBase
        then .numbers += [$result]
        else .
        end
      end
    end
  end
  | .numbers ;

# input: global object
# output: updated global object
def nextDigit($dgt; $depth):
  if $depth < maxBase-1
  then reduce range($dgt; maxBase) as $i (.;
         .usedDigits[$dgt] += 1
         | nextDigit($i; $depth+1)
         | .usedDigits[$dgt] += -1 )
  else .
  end
  | reduce range(if $dgt == 0 then 1 else $dgt end; maxBase) as $i (.;
      .usedDigits[$i] += 1
      | .numbers = calcNum($depth)
      | .usedDigits[$i] += -1 ) ;

def main:
    { usedDigits: [range(0; maxBase)|0],
      powerDgt: initPowerDgt,
      numbers:[] }
    | nextDigit(0; 0)
    | .numbers
    | unique[]
    ;

"Own digits power sums for N = 3 to 9 inclusive:",
main
