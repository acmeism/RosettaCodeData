import itertools

try: input = raw_input
except: pass

s = input()
groups = []
for _, g in itertools.groupby(s):
    groups.append(''.join(g))
print('      input string:  %s' % s)
print('     output string:  %s' % ', '.join(groups))
