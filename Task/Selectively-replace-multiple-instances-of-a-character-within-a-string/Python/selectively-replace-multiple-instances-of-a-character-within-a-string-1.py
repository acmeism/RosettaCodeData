from collections import defaultdict

rep = {'a' : {1 : 'A', 2 : 'B', 4 : 'C', 5 : 'D'}, 'b' : {1 : 'E'}, 'r' : {2 : 'F'}}

def trstring(oldstring, repdict):
    seen, newchars = defaultdict(lambda:1, {}), []
    for c in oldstring:
        i = seen[c]
        newchars.append(repdict[c][i] if c in repdict and i in repdict[c] else c)
        seen[c] += 1
    return ''.join(newchars)

print('abracadabra ->', trstring('abracadabra', rep))
