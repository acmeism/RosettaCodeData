### PEG infrastructure
def box(E):
  ((.result = null) | E) as $e
  | .remainder = $e.remainder
  | .result += [$e.result]  # the magic sauce
  ;

### Tokenize the RPN string.
# Input: a string representing an expression using RPN.
# Output: an array of corresponding tokens.
def tokens:
  [splits("[ \n\r\t]+")]
  | map(select(. != "")
  | . as $in
  | try tonumber catch $in);

### Parse the reversed array of tokens as produced by `tokens`.
# On entry, .remainder should be the reversed array.
# Output: {remainder, result}
def rrpn:
  def found: .result += [.remainder[0]] | (.remainder |= .[1:]);
  def nonempty: select(.remainder|length>0);
  def check(predicate):
     nonempty | select(.remainder[0] | predicate);

  def recognize(predicate): check(predicate) | found;

  def number  : recognize(type=="number");
  def operator: recognize(type=="string");
  def operand :  number // rrpn;
  box(operator | operand | operand);

# Input: an array of tokens as produced by `tokens`
# Output: the infix equivalent expressed as a string.
def tokens2infix:
    def infix:
      if type != "array" then .
      elif length == 1 then .[0] | infix
      elif length == 3 then "(\(.[2] | infix) \(.[0]) \(.[1] | infix))"
      else error
      end;

  {remainder: reverse} | rrpn | .result | infix;

# Input: an RPN string
# Output: the equivalent expression as a string using infix notation
def rpn2infix: tokens | tokens2infix;

def tests:
 "3 4 2 * 1 5 - 2 3 ^ ^ / +",
 "1 2 + 3 4 + ^ 5 6 + ^"
;

tests | "\"\(.)\" =>", rpn2infix, ""
