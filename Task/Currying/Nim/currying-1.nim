proc addN[T](n: T): auto = (proc(x: T): T = x + n)

let add2 = addN(2)
echo add2(7)
