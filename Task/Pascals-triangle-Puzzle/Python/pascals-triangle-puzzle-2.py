from csp import Problem

p = Problem()
pvars = "R2 R3 R5 R6 R7 R8 R9 R10 X Y Z".split()
# 0-151 is the possible finite range of the variables
p.addvars(pvars, xrange(152))
p.addrule("R7 == X + 11")
p.addrule("R8 == Y + 11")
p.addrule("R9 == Y + 4")
p.addrule("R10 == Z + 4")
p.addrule("R7 + R8 == 40")
p.addrule("R5 == R8 + R9")
p.addrule("R6 == R9 + R10")
p.addrule("R2 == 40 + R5")
p.addrule("R3 == R5 + R6")
p.addrule("R2 + R3 == 151")
p.addrule("Y == X + Z")
for sol in p.xsolutions():
    print [sol[k] for k in "XYZ"]
