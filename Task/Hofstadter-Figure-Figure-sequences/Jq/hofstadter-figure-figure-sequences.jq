def init: {r: [0, 1], s: [0, 2] };

# input: {r,s}
# output: {r,s,emit} where .emit is either null or the next R and where either .r or .s on output has been extended.
# .emit is provided in case an unbounded stream of R values is desired.
def extend_ff:
  (.r|length) as $rn
  | if .s[$rn - 1]
    then .emit = .r[$rn - 1] + .s[$rn - 1]
    | .r[$rn] = .emit
    | reduce range( [.r[$rn-1], .s[-1]] | max + 1; .r[$rn] ) as $i (.; .s += [$i] )
    else .emit = null
    | .s += [.r[$rn - 1] + 1]
    end;

def ffr($n):
  first(init | while(true; extend_ff) | select(.r[$n])).r[$n] ;

def ffs($n):
  first(init | while(true; extend_ff) | select(.s[$n])).s[$n] ;

def task1($n):
  "The first \($n) values of R are:",
  (init | until( .r | length > $n; extend_ff) | .r[1:]) ;

def task2:
  "The result of checking that the first 40 values of R and the first 960 of S together cover the interval [1,1000] is:",
  ( init | until( (.r|length) > 40 and (.s|length) > 960; extend_ff)
   | (.r[1:41] + .s[1:961] | sort) == [range(1;1001)] ) ;

task1(10), task2
