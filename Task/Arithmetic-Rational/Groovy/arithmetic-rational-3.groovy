Number.metaClass.mixin RationalCategory

def x = [5, 20] as Rational
def y = [9, 12] as Rational
def z = [0, 10000] as Rational

println x
println y
println z
println (x <=> y)
println (x.compareTo(y))
assert x < y
assert x*3 == y
assert x*5.5 == 5.5*x
assert (z + 1) <= y*4
assert x + 1.3 == 1.3 + x
assert 24 - y == -(y - 24)
assert 3 / y == (y / 3).reciprocal()
assert x != y

println "x + y == ${x} + ${y} == ${x + y}"
println "x + z == ${x} + ${z} == ${x + z}"
println "x - y == ${x} - ${y} == ${x - y}"
println "x - z == ${x} - ${z} == ${x - z}"
println "x * y == ${x} * ${y} == ${x * y}"
println "y ** 3 == ${y} ** 3 == ${y ** 3}"
println "y ** -3 == ${y} ** -3 == ${y ** -3}"
println "x * z == ${x} * ${z} == ${x * z}"
println "x / y == ${x} / ${y} == ${x / y}"
try { print "x / z == ${x} / ${z} == "; println "${x / z}" }
catch (Throwable t) { println t.message }

println "-x == -${x} == ${-x}"
println "-y == -${y} == ${-y}"
println "-z == -${z} == ${-z}"

print "x as int == ${x} as int == "; println x.intValue()
print "x as double == ${x} as double == "; println x.doubleValue()
print "1 / x as int == 1 / ${x} as int == "; println x.reciprocal().intValue()
print "1.0 / x == 1.0 / ${x} == "; println x.reciprocal().doubleValue()
print "y as int == ${y} as int == "; println y.intValue()
print "y as double == ${y} as double == "; println y.doubleValue()
print "1 / y as int == 1 / ${y} as int == "; println y.reciprocal().intValue()
print "1.0 / y == 1.0 / ${y} == "; println y.reciprocal().doubleValue()
print "z as int == ${z} as int == "; println z.intValue()
print "z as double == ${z} as double == "; println z.doubleValue()
try { print "1 / z as int == 1 / ${z} as int == "; println z.reciprocal().intValue() }
catch (Throwable t) { println t.message }
try { print "1.0 / z == 1.0 / ${z} == "; println z.reciprocal().doubleValue() }
catch (Throwable t) { println t.message }

println "++x == ++ ${x} == ${++x}"
println "++y == ++ ${y} == ${++y}"
println "++z == ++ ${z} == ${++z}"
println "-- --x == -- -- ${x} == ${-- (--x)}"
println "-- --y == -- -- ${y} == ${-- (--y)}"
println "-- --z == -- -- ${z} == ${-- (--z)}"
println x
println y
println z

println (x <=> y)
assert x*3 == y
assert (z + 1) <= y*4
assert (x < y)

println 25 as Rational
println 25.0 as Rational
println 0.25 as Rational

def ε = 0.000000001  // tolerance (epsilon): acceptable "wrongness" to account for rounding error

def π = Math.PI
def α = π as Rational
assert (π - (α as BigDecimal)).abs() < ε
println π
println α
println (α.toBigDecimal())
println (α as BigDecimal)
println (α as Double)
println (α as double)
println (α as boolean)
println (z as boolean)
try { println (α as Date) }
catch (Throwable t) { println t.message }
try { println (α as char) }
catch (Throwable t) { println t.message }
