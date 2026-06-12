def Element:
  parse("(?<e>^[A-Z][a-z]*)"); # greedy

def Number: parseNumber("^[0-9]+"); # greedy

def EN: Element | optional(Number);

def Parenthesized:
   consume("[(]")
   | box( (plus(EN) | optional(Parenthesized)) // (Parenthesized | plus(EN)) )
   | consume("[)]")
   | Number;

def Formula:
     (plus(EN) | Parenthesized | Formula)
  // (plus(EN) | optional(Parenthesized))
  // (Parenthesized | optional(Formula)) ;
