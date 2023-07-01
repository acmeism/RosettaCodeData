def cruncher = { x1, x2, program ->
   Eval.x(x1, program) - Eval.x(x2, program)
}
