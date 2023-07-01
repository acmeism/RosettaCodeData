def list = 1..10
def A = arithMean(list)
def G = geomMean(list)
assert A >= G
def H = harmMean(list)
assert G >= H
println """
list: ${list}
   A: ${A}
   G: ${G}
   H: ${H}
"""
