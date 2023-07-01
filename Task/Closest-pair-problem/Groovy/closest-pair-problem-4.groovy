def random = new Random()

(1..4).each {
def point10 = (0..<(10**it)).collect { new Point(random.nextInt(1000001) - 500000,random.nextInt(1000001) - 500000) }

def startE = System.currentTimeMillis()
def closestE = elegantClosest(point10)
def elapsedE = System.currentTimeMillis() - startE
println """
${10**it} POINTS
-----------------------------------------
Elegant reduction:
elapsed: ${elapsedE/1000} s
closest: ${closestE}
"""


def startB = System.currentTimeMillis()
def closestB = bruteClosest(point10)
def elapsedB = System.currentTimeMillis() - startB
println """Brute force:
elapsed: ${elapsedB/1000} s
closest: ${closestB}

Speedup ratio (B/E): ${elapsedB/elapsedE}
=========================================
"""
}
