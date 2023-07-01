import constraint

depts = ( 'police', 'sanitation', 'fire' )

p = constraint.Problem()

for var in depts:
    p.addVariable(var, range(1,8))

p.addConstraint(constraint.AllDifferentConstraint())
p.addConstraint(lambda *vars: sum(vars)==12, depts)
p.addConstraint(lambda p: p%2==0, ('police',))

for s in p.getSolutions():
    print(s)
