# Preliminaries:
# This def can be omitted if using jq or gojq:
def range($a;$b;$c): $a | while(. < $b; .+$c);

# jaq does not support string interpolation so, for brevity:
def tos: tostring;

# The following def should be modified if an alternative mechanism for
# reading the parameter arguments is used:
def args:  {args: [splits("  *")]};

def argsSize: .args|length;

# Input: an array
# Emit the items in the array until the condition on the items is met.
# The item for which the condition is first met is NOT emitted.
def emit_until(cond):
  length as $length
  | if $length == 0 or (.[0]|cond) then empty
    else . as $in
    | {i:0, ok: true}
    | while(.ok;
       .i+=1
      | .ok = .i < $length and ($in[.i] | cond | not) )
    | $in[.i]
    end;

# input: a number or a string
# If the input is or can be converted to a number using tonumber, then return the number
# else return false.
def isnumber:
 if type == "number" then .
 elif type == "string" then tonumber? // false
 else false
 end;

# input: anything
# output: a boolean
def isinteger:
  if type == "number" then . == floor
  else isnumber as $x
  | if $x then $x | (. == floor) else false end
  end;

# mark and collapse
def removeEvery($n):
  reduce range($n-1; length; $n) as $i (.; .[$i]=null)
  | map(select(.));

# Input: {lucky}
def filterLucky:
  (.lucky|length) as $length
  | .n = 2
  | until( .n >= $length;
      .lucky[.n-1] as $m
      | if $m then .lucky |= removeEvery($m) | .n += 1
        else .n = $length
        end )
  | del(.n);

def printSingle($j):
  if $j >= 1 + (.lucky|length) then "Argument is too big" | error
  else
    (if .odd then "Lucky number #" else "Lucky even number #" end)
    + ($j|tos) + " = " + (.lucky[$j-1]|tos)
  end;

# like jq's range($j-1; $k)
def printRange($j; $k):
  if $k >= (.lucky|length) then "Argument " + ($k|tos) + " is too big" | error
  elif .odd
  then "Lucky numbers " + ($j|tos) + " to " + ($k|tos) + " inclusive are:",
       .lucky[$j-1:$k]
  else "Lucky even numbers " + ($j|tos) + " to " + ($k|tos) + " inclusive are:",
       .lucky[$j-1:$k]
  end;

def printBetween($j; $k):
  .lucky[-1] as $max
  | if $j > $max or $k > $max
    then "At least one argument is too big" | error
    else
      (if .odd
       then "Lucky numbers between " + ($j|tos) + " and " + ($k|tos) + " are:"
       else "Lucky even numbers between " + ($j|tos) + " and " + ($k|tos) + " are:"
       end),
      [.lucky | emit_until(. > $k) | select(. >= $j)]
    end;

def odd:
  if argsSize < 3 then true
  else (.args[2] | tostring | ascii_downcase)
  | if . == "lucky" or . == "odd" then true
    elif . == "evenlucky" or . == "even" then false
    else "Third argument " + (.args[2]|tos) + " is invalid" | error
    end
  end;

# Input: {odd}
def init($n):
  if .odd
  then .lucky = reduce range(0;$n) as $i (null; . + [$i*2 + 1])
  else .lucky = reduce range(0;$n) as $i (null; . + [$i*2 + 2])
  end;

# Emit {args, j, k, odd, single} or raise an error
def gatherArgs:
  args
  | if argsSize | (. < 1 or . > 3)
    then "There must be between 1 and 3 command line arguments" | error
    else .j = (.args[0] | isnumber )
    | .k = (.args[1] | isnumber )
    | .single = (argsSize == 1 or .args[1] == ",")
    | .odd = odd
    | if (.j | isinteger | not) or (.j < 1)
      then "First argument " + (.args[0]|tos) + " must be a positive integer" | error
      elif argsSize >= 2 and .args[1] != "," and (.k | isinteger | not)
      then "Second argument " + (.args[1]|tos) + " must be an integer or ," | error
      else .
      end
    | if .k and .k >= 0 and .j > .k
      then "Second argument cannot be less than first" | error
      else .
      end
    end ;

def start:
  gatherArgs
  | (if .k then (if .k > 0 then .k else null end) else .j end) as $size
  | (if $size then ($size | . * (tostring|length|.*.)) else -.k end) as $size
  | init($size)
  | filterLucky
  | if .single      then printSingle(.j)
    elif .k > 0     then printRange(.j; .k)
    else .k |= - .
    | if (.j > .k)
      then "The second argument cannot be less in absolute value than first" | error
      else printBetween(.j; .k)
      end
    end;

start
