def eParser := <elang:syntax.makeEParser>
def LiteralExpr := <elang:evm.makeLiteralExpr>.asType()
def arithEvaluate(expr :String) {
  def ast := eParser(expr)

  def evalAST(ast) {
    return switch (ast) {
      match e`@a + @b` { evalAST(a) + evalAST(b) }
      match e`@a - @b` { evalAST(a) - evalAST(b) }
      match e`@a * @b` { evalAST(a) * evalAST(b) }
      match e`@a / @b` { evalAST(a) / evalAST(b) }
      match e`-@a` { -(evalAST(a)) }
      match l :LiteralExpr { l.getValue() }
    }
  }

  return evalAST(ast)
}
