import sugar

proc addM[T](n: T): auto = (x: T) => x + n

let add3 = addM(3)
echo add3(7)
