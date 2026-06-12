def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Input: a string in base $b (2 to 35 inclusive)
# Output: the decimal value
def frombase($b):
  def decimalValue:
    if   48 <= . and . <= 57 then . - 48
    elif 65 <= . and . <= 90 then . - 55  # (10+.-65)
    elif 97 <= . and . <= 122 then . - 87 # (10+.-97)
    else "decimalValue" | error
    end;
  reduce (explode|reverse[]|decimalValue) as $x ({p:1};
    .value += (.p * $x)
    | .p *= $b)
  | .value ;
