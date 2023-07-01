while True:
    x, y, z = eval(input('Three Python values: '))
    print(f'As read: x = {x!r}; y = {y!r}; z = {z!r}')
    x, y, z = sorted((x, y, z))
    print(f' Sorted: x = {x!r}; y = {y!r}; z = {z!r}')
