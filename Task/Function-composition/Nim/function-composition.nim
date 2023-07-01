import sugar

proc compose[A,B,C](f: B -> C, g: A -> B): A -> C = (x: A) => f(g(x))

proc plustwo(x: int): int = x + 2
proc minustwo(x: int): int = x - 2

var plusminustwo = compose(plustwo, minustwo)
echo plusminustwo(10)
