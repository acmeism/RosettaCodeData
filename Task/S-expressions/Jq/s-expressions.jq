# PEG infrastructure
def star(E): ((E | star(E)) // .) ;

### Helper functions:
# Consume a regular expression rooted at the start of .remainder, or emit empty;
# on success, update .remainder and set .match but do NOT update .result
def consume($re):
  # on failure, match yields empty
  (.remainder | match("^" + $re)) as $match
  | .remainder |= .[$match.length :]
  | .match = $match.string;

def parse($re):
  consume($re)
  | .result = .result + [.match] ;

def parseNumber($re):
  consume($re)
  | .result = .result + [.match|tonumber] ;

def eos: select(.remainder == "");

# whitespace
def ws: consume("[ \t\r\n]*");

def box(E):
  ((.result = null) | E) as $e
  | .remainder = $e.remainder
  | .result += [$e.result]  # the magic sauce
  ;

# S-expressions

# Input: a string
# Output: an array representation of the input if it is an S-expression
def SExpression:
  def string:     consume("\"") | parse("[^\"]") | consume("\"");
  def identifier: parse("[^ \t\n\r()]+");
  def decimal:    parseNumber("[0-9]+([.][0-9]*)?");
  def hex:        parse("0x[0-9A-Fa-f]+") ;
  def number:     hex // decimal;
  def atom:       ws | (string // number // identifier);

  def SExpr:      ws | consume("[(]") | ws | box(star(atom // SExpr)) | consume("[)]");

  {remainder: .} | SExpr | ws | eos | .result;

SExpression
