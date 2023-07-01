pragma.enable("lambda-args") # The feature is still experimental syntax

def makeIf2Control(evalFn, tf, ft, ff) {
  return def if2Control {
    to only1__control_0(tf) { return makeIf2Control(evalFn, tf, ft, ff) }
    to only2__control_0(ft) { return makeIf2Control(evalFn, tf, ft, ff) }
    to else__control_0 (ff) { return makeIf2Control(evalFn, tf, ft, ff) }
    to run__control() {
      def [[a :boolean, b :boolean], # Main parameters evaluated
           tt                        # First block ("then" case)
          ] := evalFn()
      return (
        if (a) { if (b) {tt} else {tf} } \
          else { if (b) {ft} else {ff} }
      )()
    }
  }
}

def if2 {
    # The verb here is composed from the keyword before the brace, the number of
    # parameters in the parentheses, and the number of parameters after the
    # keyword.
    to then__control_2_0(evalFn) {
        # evalFn, when called, evaluates the expressions in parentheses, then
        # returns a pair of those expressions and the first { block } as a
        # closure.
        return makeIf2Control(evalFn, fn {}, fn {}, fn {})
    }
}

for a in [false,true] {
    for b in [false,true] {
        if2 (a, b) then {
            println("both")
        } only1 {
            println("a true")
        } only2 {
            println("b true")
        } else {
            println("neither")
        }
    }
}
