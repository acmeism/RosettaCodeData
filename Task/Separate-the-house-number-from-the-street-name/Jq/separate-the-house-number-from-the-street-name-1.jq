def regex:
   "^ (?<s>.*?) \\s+"
 + "  (?<n>\\d* ( \\-|\\/)? \\d*"
 + "              | \\d{1,3} [a-zI./ ]* \\d{0,3}"
 + "            )$";

# Output: {s, n}
# If the input cannot be parsed,
# then .s is a copy of the the input, and .n is "(Error)"
def parseStreetNumber:
  capture(regex; "x")
    // capture( "^(?<s>.*'40 *- *'45) *$" )
    // {s: ., n: "(Error)"}
  | .n |= if . == "" or . == null then "(none)" else . end ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
