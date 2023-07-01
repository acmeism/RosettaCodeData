# Input: an array representing a stack, with .[-1] being its top.
# Output: the updated array after applying `op`
def rpn(op):
  def two: .[-2:];
  def update($x): (.[:-2] + [$x]);
  if length<=1 then .
  elif op == "+" then update(two | add)
  elif op == "*" then update(two | (.[0] * .[1]))
  elif op == "/" then update(two | (.[0] / .[1]))
  elif op == "-" then update(two | (.[0] - .[1]))
  elif op == "^" then update(two | (pow(.[0]; .[1])))
  else ("ignoring unrecognized op \(op)" | debug) as $debug | .
  end;

def eval:
   foreach .[] as $item ([];
      if ($item | type) == "number" then . + [$item]
      else rpn($item)
      end;
      "\($item) => \(.)" ) ;

"3 4 2 * 1 5 - 2 3 ^ ^ / +"
| split(" ") | map( (try tonumber) // .)
| eval
