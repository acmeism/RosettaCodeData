def sq = { it * it }
def plus1 = { it + 1 }
def minus1 = { it - 1 }

def plus1sqd = compose(sq,plus1)
def sqminus1 = compose(minus1,sq)
def identity = compose(plus1,minus1)
def plus1sqdminus1 = compose(minus1,compose(sq,plus1))
def identity2 = compose(Math.&sin,Math.&asin)

println "(x+1)**2 = (0+1)**2 = " + plus1sqd(0)
println "x**2-1 = 20**2-1 = " + sqminus1(20)
println "(x+1)-1 = (12+1)-1 = " + identity(12)
println "(x+1)**2-1 = (3+1)**2-1 = " + plus1sqdminus1(3)
println "sin(asin(x)) = sin(asin(1)) = " + identity2(1)
