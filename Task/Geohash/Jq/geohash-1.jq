def lpad($len; $c): tostring | ($len - length) as $l | ($c * $l)[:$l] + .;

def lpad($len): lpad($len; " ");

def round($digits): pow(10; $digits) as $p | . * $p | round | floor | . / $p;

# Convert the input integer to a string in the specified base (2 to 36 inclusive)
def convert(base):
  def stream:
    recurse(if . >= base then ./base|floor else empty end) | . % base ;
  [stream] | reverse
  | if   base <  10 then map(tostring) | join("")
    elif base <= 36 then map(if . < 10 then 48 + . else . + 87 end) | implode
    else error("base too large")
    end;

# counting from 0
def enumerate(s): foreach s as $x (-1; .+1; [., $x]);

def to_object(s; o):
  reduce s as $x ({}; . + ($x|o));
