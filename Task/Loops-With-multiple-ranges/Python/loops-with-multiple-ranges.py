from itertools import chain

prod, sum_, x, y, z, one,three,seven = 1, 0, 5, -5, -2, 1, 3, 7

def _range(x, y, z=1):
    return range(x, y + (1 if z > 0 else -1), z)

print(f'list(_range(x, y, z)) = {list(_range(x, y, z))}')
print(f'list(_range(-seven, seven, x)) = {list(_range(-seven, seven, x))}')

for j in chain(_range(-three, 3**3, three), _range(-seven, seven, x),
               _range(555, 550 - y), _range(22, -28, -three),
               _range(1927, 1939), _range(x, y, z),
               _range(11**x, 11**x + 1)):
    sum_ += abs(j)
    if abs(prod) < 2**27 and (j != 0):
        prod *= j
print(f' sum= {sum_}\nprod= {prod}')
