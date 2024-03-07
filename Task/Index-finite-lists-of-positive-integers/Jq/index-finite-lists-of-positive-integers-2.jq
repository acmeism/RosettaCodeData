### Infrastructure

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

def binary_digits:
  if . == 0 then 0
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2 | tostring]
    | reverse
    | .[1:] # remove the leading 0
    | join("")
  end ;


### rank and unrank
# Each integer n in the list is mapped to '1' plus n '0's.
# The empty list is mapped to '0'
def rank:
  if length == 0 then 0
  else reduce .[] as $i ("";
    . += "1" + ("0" * $i))
  | frombase(2)
  end ;

def unrank:
  if . == 0 then []
  else binary_digits
  | split("1")
  | .[1:]
  | map(length)
  end ;

### Illustration
range(1;11)
| . as $i
| unrank
| . as $unrank
| [$i, $unrank, rank]
