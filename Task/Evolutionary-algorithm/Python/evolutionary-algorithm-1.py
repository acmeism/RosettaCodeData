from string import letters
from random import choice, random

target  = list("METHINKS IT IS LIKE A WEASEL")
charset = letters + ' '
parent  = [choice(charset) for _ in range(len(target))]
minmutaterate  = .09
C = range(100)

perfectfitness = float(len(target))

def fitness(trial):
    'Sum of matching chars by position'
    return sum(t==h for t,h in zip(trial, target))

def mutaterate():
    'Less mutation the closer the fit of the parent'
    return 1-((perfectfitness - fitness(parent)) / perfectfitness * (1 - minmutaterate))

def mutate(parent, rate):
    return [(ch if random() <= rate else choice(charset)) for ch in parent]

def que():
    '(from the favourite saying of Manuel in Fawlty Towers)'
    print ("#%-4i, fitness: %4.1f%%, '%s'" %
           (iterations, fitness(parent)*100./perfectfitness, ''.join(parent)))

def mate(a, b):
    place = 0
    if choice(xrange(10)) < 7:
        place = choice(xrange(len(target)))
    else:
        return a, b

    return a, b, a[:place] + b[place:], b[:place] + a[place:]

iterations = 0
center = len(C)/2
while parent != target:
    rate = mutaterate()
    iterations += 1
    if iterations % 100 == 0: que()
    copies = [ mutate(parent, rate) for _ in C ]  + [parent]
    parent1 = max(copies[:center], key=fitness)
    parent2 = max(copies[center:], key=fitness)
    parent = max(mate(parent1, parent2), key=fitness)
que()
