def Expr:

  def ws: consume(" *");

  def Number: ws | parseNumber( "-?[0-9]+([.][0-9]*)?" );

  def Sum:
    def Parenthesized: ws | consume("[(]") | ws | box(Sum) | ws | consume("[)]");
    def Factor: Parenthesized // Number;
    def Product: box(Factor | star( ws | (literal("*") // literal("/")) | Factor));
    Product | ws | star( (literal("+") // literal("-")) | Product);

  Sum;
