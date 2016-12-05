import future

proc compose[A,B,C](f: A -> B, g: B -> C): A -> C = (x: A) => f(g(x))

proc plustwo(x: int): int = x + 2
proc minustwo(x: int): int = x - 2

var plusminustwo = compose(plustwo, minustwo)
echo plusminustwo(10)
