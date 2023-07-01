pragma.enable("accumulator")

def leftRect(f, x, h) {
  return f(x)
}

def midRect(f, x, h) {
  return f(x + h/2)
}

def rightRect(f, x, h) {
  return f(x + h)
}

def trapezium(f, x, h) {
  return (f(x) + f(x+h)) / 2
}

def simpson(f, x, h) {
  return (f(x) + 4 * f(x + h / 2) + f(x+h)) / 6
}

def integrate(f, a, b, steps, meth) {
   def h := (b-a) / steps
   return h * accum 0 for i in 0..!steps { _ + meth(f, a+i*h, h) }
}
