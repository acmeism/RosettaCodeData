Number.metaClass.mixin VectorCategory

def a = [1, 5] as Vector
def b = [6, -2] as Vector
def x = 8
println "a = $a    b = $b    x = $x"
assert a + b == [7, 3] as Vector
println "a + b == $a + $b == ${a+b}"
assert a - b == [-5, 7] as Vector
println "a - b == $a - $b == ${a-b}"
assert a * x == [8, 40] as Vector
println "a * x == $a * $x == ${a*x}"
assert x * a == [8, 40] as Vector
println "x * a == $x * $a == ${x*a}"
assert b / x == [3/4, -1/4] as Vector
println "b / x == $b / $x == ${b/x}"
