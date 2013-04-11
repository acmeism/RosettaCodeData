def x = new Rational(5, 20)
def y = new Rational(9, 12)
def z = new Rational(0, 10000)

println x
println y
println z
println (x <=> y)
println ((x as Rational).compareTo(y))
assert x*3 == y
assert (z + 1) <= y*4
assert x != y

println "x + y == ${x} + ${y} == ${x + y}"
println "x + z == ${x} + ${z} == ${x + z}"
println "x - y == ${x} - ${y} == ${x - y}"
println "x - z == ${x} - ${z} == ${x - z}"
println "x * y == ${x} * ${y} == ${x * y}"
println "y ** 3 == ${y} ** 3 == ${y ** 3}"
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

println (new Rational(25))
println (new Rational(25.0))
println (new Rational(0.25))

println Math.PI
println (new Rational(Math.PI))
println ((new Rational(Math.PI)).toBigDecimal())
println ((new Rational(Math.PI)) as BigDecimal)
println ((new Rational(Math.PI)) as Double)
println ((new Rational(Math.PI)) as double)
println ((new Rational(Math.PI)) as boolean)
println (z as boolean)
try { println ((new Rational(Math.PI)) as Date) }
catch (Throwable t) { println t.message }
try { println ((new Rational(Math.PI)) as char) }
catch (Throwable t) { println t.message }
