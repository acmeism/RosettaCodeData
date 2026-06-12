def expr:
  def Digit        :  parse("[0-9]");

  def Letter       :  parse("[a-zA-Z]");

  def Identifier   :  Letter | star(Letter // Digit // literal("_"));

  def Integer      :  plus(Digit);

  def primary      :  ws
                      | (Identifier
                        // Integer
                        // (literal("(") | expr | literal(")"))
                        // literal("true")
                        // literal("false"))
		      | ws;

  def expr_level_6 :  primary | star((literal("*") // literal("/")) | primary) ;
  def expr_level_5 :  expr_level_6 | star((literal("+") // literal("-")) | expr_level_6) ;
  def expr_level_4 :  ws | optional(literal("not")) | expr_level_5 | optional(parse("[=<]") | expr_level_5) ;
  def expr_level_3 :  expr_level_4 | star(literal("and") | expr_level_4) ;
  def expr_level_2 :  expr_level_3 | star(literal("or")  | expr_level_3) ;

  ws | expr_level_2 | ws;

def stmt:
  {remainder: .} | expr | eos;
