def literal($s):
  select(.remainder | startswith($s))
  | .result += [$s]
  | .remainder |= .[$s | length :] ;

def box(E):
   ((.result = null) | E) as $e
   | .remainder = $e.remainder
   | .result += [$e.result]  # the magic sauce
   ;

# Consume a regular expression rooted at the start of .remainder, or emit empty;
# on success, update .remainder and set .match but do NOT update .result
def consume($re):
  # on failure, match yields empty
  (.remainder | match("^" + $re)) as $match
  | .remainder |= .[$match.length :]
  | .match = $match.string ;

def parseNumber($re):
  consume($re)
  | .result = .result + [.match|tonumber] ;
