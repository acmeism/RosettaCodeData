from random import randint

def equal_birthdays(sharers=2, groupsize=23, rep=100000):
    'Note: 4 sharing common birthday may have 2 dates shared between two people each'
    g = range(groupsize)
    sh = sharers - 1
    eq = sum((groupsize - len(set(randint(1,365) for i in g)) >= sh)
             for j in range(rep))
    return (eq * 100.) / rep

def equal_birthdays(sharers=2, groupsize=23, rep=100000):
    'Note: 4 sharing common birthday must all share same common day'
    g = range(groupsize)
    sh = sharers - 1
    eq = 0
    for j in range(rep):
        group = [randint(1,365) for i in g]
        if (groupsize - len(set(group)) >= sh and
            any( group.count(member) >= sharers for member in set(group))):
            eq += 1
    return (eq * 100.) / rep

group_est = [2]
for sharers in (2, 3, 4, 5):
    groupsize = group_est[-1]+1
    while equal_birthdays(sharers, groupsize, 100) < 50.:
        # Coarse
        groupsize += 1
    for groupsize in range(int(groupsize - (groupsize - group_est[-1])/4.), groupsize + 999):
        # Finer
        eq = equal_birthdays(sharers, groupsize, 250)
        if eq > 50.:
            break
    for groupsize in range(groupsize - 1, groupsize +999):
        # Finest
        eq = equal_birthdays(sharers, groupsize, 50000)
        if eq > 50.:
            break
    group_est.append(groupsize)
    print("%i independent people in a group of %s share a common birthday. (%5.1f)" % (sharers, groupsize, eq))
