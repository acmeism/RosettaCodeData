# read($wheel)
# where $wheel is the wheel to be read (a string)
# Input: a set of wheels
# Output: an object such that .value is the next value,
# and .state is the updated state of the set of wheels
def read($wheel):

  # Input: an array
  # Output: the rotated array
  def rotate: .[1:] + [.[0]];

  .[$wheel][0] as $value
  | (.[$wheel] |= rotate) as $state
  | if ($value | type) == "number"
    then {$value, $state}
    else $state | read($value)
    end;

# Read wheel $wheel $n times
def multiread($wheel; $n):
  if $n <= 0 then empty
  else read($wheel)
  | .value, (.state | multiread($wheel; $n - 1))
  end;

def printWheels:
  keys[] as $k
  | "\($k): \(.[$k])";

# Spin each group $n times
def spin($n):
  wheels[]
  | "The number wheel group:",
    printWheels,
    "generates",
    ([ multiread("A"; $n)  ] | join(" ") + " ..."),
    "";

spin(20)
