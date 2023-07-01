import re
from itertools import islice # To limit execution if it would generate huge values
# list(islice('ABCDEFG', 2)) --> ['A', 'B']
# list(islice('ABCDEFG', 4)) --> ['A', 'B', 'C', 'D']


data = '''
start 	stop 	increment 	Comment
-2 	2 	1 	Normal
-2 	2 	0 	Zero increment
-2 	2 	-1 	Increments away from stop value
-2 	2 	10 	First increment is beyond stop value
2 	-2 	1 	Start more than stop: positive increment
2 	2 	1 	Start equal stop: positive increment
2 	2 	-1 	Start equal stop: negative increment
2 	2 	0 	Start equal stop: zero increment
0 	0 	0 	Start equal stop equal zero: zero increment
'''

table = [re.split(r'\s\s+', line.strip()) for line in data.strip().split('\n')]
#%%
for _start, _stop, _increment, comment in table[1:]:
    start, stop, increment = [int(x) for x in (_start, _stop, _increment)]
    print(f'{comment.upper()}:\n  range({start}, {stop}, {increment})')
    values = None
    try:
        values = list(islice(range(start, stop, increment), 999))
    except ValueError as e:
        print('  !!ERROR!!', e)
    if values is not None:
        if len(values) < 22:
            print('    =', values)
        else:
            print('    =', str(values[:22])[:-1], '...')
