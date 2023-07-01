# If $j is 0, then an error condition is raised;
# otherwise, assuming infinite-precision integer arithmetic,
# if the input and $j are integers, then the result will be an integer.
def idivide($j): (. - (. % $j)) / $j ;

# shift left
def left8: 256 * .;

# shift right
def right8: idivide(256);

def modPow($b; $e; $m):
   if ($m == 1) then 0
   else {b: ($b % $m), $e, r: 1}
   | until( .e <= 0 or .return;
       if .b == 0 then .return = 0
       else if .e % 2 == 1 then .r = (.r * .b) % $m else . end
       | .e |= idivide(2)
       | .b = (.b * .b) % $m
       end)
   | if .return then .return else .r end
   end;

# Convert the input integer to a stream of 8-bit integers, most significant first
def bytes:
  def stream:
    recurse(if . >= 256 then ./256|floor else empty end) | . % 256 ;
  [stream] | reverse ;

# convert ASCII plain text to a number
def ptn:
  reduce explode[] as $b (0; left8 + $b);

def n: 9516311845790656153499716760847001433441357;
def e: 65537;
def d: 5617843187844953170308463622230283376298685;

# encode a single number
def etn: . as $ptn | modPow($ptn; e; n);

# decode a single number
def dtn: . as $etn | modPow($etn; d; n);

def decode:
  [recurse(right8 | select(.>0)) % 256]
  | reverse
  | implode;

def task($pt):
  ($pt|ptn) as $ptn
  | if ($ptn >= n) then "Plain text message too long" | error else . end
  | ($ptn|etn) as $etn
  | ($etn|dtn) as $dtn
  | ($ptn|decode) as $text
  | "Plain text:            : \($pt)",
    "Plain text as a number : \($ptn)",
    "Encoded                : \($etn)",
    "Decoded                : \($dtn)",
    "Decoded number as text : \($text)"
 ;

task("Rosetta Code"),
"",
task("Hello, Rosetta!!!!")
