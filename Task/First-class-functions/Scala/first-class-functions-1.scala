import math._

// functions as values
val cube = (x: Double) => x * x * x
val cuberoot = (x: Double) => pow(x, 1 / 3d)

// higher order function, as a method
def compose[A,B,C](f: B => C, g: A => B) = (x: A) => f(g(x))

// partially applied functions in Lists
val fun = List(sin _, cos _, cube)
val inv = List(asin _, acos _, cuberoot)

// composing functions from the above Lists
val comp = (fun, inv).zipped map (_ compose _)

// output results of applying the functions
comp foreach {f => print(f(0.5) + "   ")}
