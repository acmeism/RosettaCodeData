# Constructing an environment has to be done by way of evaluation
#for historical reasons which will hopefully be entirely eliminated soon.
def bindX(value) {
  def [resolver, env] := e`    # bind x and capture its resolver and the
    def x                      # resulting environment
  `.evalToPair(safeScope)
  resolver.resolve(value)      # set the value
  return env
}

def evalWithX(program, a, b) {
  def atA := program.eval(bindX(a))
  def atB := program.eval(bindX(b))
  return atB - atA
}
