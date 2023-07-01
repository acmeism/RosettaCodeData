include "peg"; # see [[:Category:jq/peg.jq]

def expr:

  def Var     :  parse("[A-Z][a-zA-Z0-9]*");

  def boolean :  (literal("true") // literal("false"))
                 | .result[-1] |= fromjson;

  def primary :  ws
                 | (Var
                    // boolean
                    // box(q("(") | expr | q(")"))
                   )
                 | ws;

  def e3      :  ws | (box(literal("not") | primary)  // primary);
  def e2      :  box(e3 | star(literal("and") | e3)) ;
  def e1      :  box(e2 | star((literal("or") // literal("xor")) | e2)) ;
  def e0      :  box(primary | literal("=>") | primary) // e1;

  ws | e0 | ws;

def statement:
  {remainder: .} | expr | eos;
