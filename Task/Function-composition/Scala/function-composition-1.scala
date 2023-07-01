def compose[A](f: A => A, g: A => A) = { x: A => f(g(x)) }

def add1(x: Int) = x+1
val add2 = compose(add1, add1)
