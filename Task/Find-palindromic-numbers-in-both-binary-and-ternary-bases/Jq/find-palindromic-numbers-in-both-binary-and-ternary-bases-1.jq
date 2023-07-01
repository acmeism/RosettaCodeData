# Convert the input integer to a string in the specified base (2 to 36 inclusive)
def convert(base):
  def stream:
    recurse(if . >= base then ./base|floor else empty end) | . % base ;
  [stream] | reverse
  | if   base <  10 then map(tostring) | join("")
    elif base <= 36 then map(if . < 10 then 48 + . else . + 87 end) | implode
    else error("base too large")
    end;

# integer division using integer operations only
def idivide($i; $j):
  ($i % $j) as $mod
  | ($i - $mod) / $j ;

def idivide($j):
  idivide(.; $j);

# If cond then show the result of update before recursing
def iterate(cond; update):
  def i: select(cond) | update | (., i);
  i;
