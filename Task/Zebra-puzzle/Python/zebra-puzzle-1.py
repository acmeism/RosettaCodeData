from logpy import *
from logpy.core import lall
import time

def lefto(q, p, list):
	# give me q such that q is left of p in list
	# zip(list, list[1:]) gives a list of 2-tuples of neighboring combinations
	# which can then be pattern-matched against the query
	return membero((q,p), zip(list, list[1:]))

def nexto(q, p, list):
	# give me q such that q is next to p in list
	# match lefto(q, p) OR lefto(p, q)
	# requirement of vector args instead of tuples doesn't seem to be documented
	return conde([lefto(q, p, list)], [lefto(p, q, list)])

houses = var()

zebraRules = lall(
	# there are 5 houses
	(eq, 		(var(), var(), var(), var(), var()), houses),
	# the Englishman's house is red
	(membero,	('Englishman', var(), var(), var(), 'red'), houses),
	# the Swede has a dog
	(membero,	('Swede', var(), var(), 'dog', var()), houses),
	# the Dane drinks tea
	(membero,	('Dane', var(), 'tea', var(), var()), houses),
	# the Green house is left of the White house
	(lefto,		(var(), var(), var(), var(), 'green'),
				(var(), var(), var(), var(), 'white'), houses),
	# coffee is the drink of the green house
	(membero,	(var(), var(), 'coffee', var(), 'green'), houses),
	# the Pall Mall smoker has birds
	(membero,	(var(), 'Pall Mall', var(), 'birds', var()), houses),
	# the yellow house smokes Dunhills
	(membero,	(var(), 'Dunhill', var(), var(), 'yellow'), houses),
	# the middle house drinks milk
	(eq,		(var(), var(), (var(), var(), 'milk', var(), var()), var(), var()), houses),
	# the Norwegian is the first house
	(eq,		(('Norwegian', var(), var(), var(), var()), var(), var(), var(), var()), houses),
	# the Blend smoker is in the house next to the house with cats
	(nexto,		(var(), 'Blend', var(), var(), var()),
				(var(), var(), var(), 'cats', var()), houses),
	# the Dunhill smoker is next to the house where they have a horse
	(nexto,		(var(), 'Dunhill', var(), var(), var()),
				(var(), var(), var(), 'horse', var()), houses),
	# the Blue Master smoker drinks beer
	(membero,	(var(), 'Blue Master', 'beer', var(), var()), houses),
	# the German smokes Prince
	(membero,	('German', 'Prince', var(), var(), var()), houses),
	# the Norwegian is next to the blue house
	(nexto,		('Norwegian', var(), var(), var(), var()),
				(var(), var(), var(), var(), 'blue'), houses),
	# the house next to the Blend smoker drinks water
	(nexto,		(var(), 'Blend', var(), var(), var()),
				(var(), var(), 'water', var(), var()), houses),
	# one of the houses has a zebra--but whose?
	(membero,	(var(), var(), var(), 'zebra', var()), houses)
)

t0 = time.time()
solutions = run(0, houses, zebraRules)
t1 = time.time()
dur = t1-t0

count = len(solutions)
zebraOwner = [house for house in solutions[0] if 'zebra' in house][0][0]

print "%i solutions in %.2f seconds" % (count, dur)
print "The %s is the owner of the zebra" % zebraOwner
print "Here are all the houses:"
for line in solutions[0]:
	print str(line)
