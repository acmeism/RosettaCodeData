# using lambda and map:
sum(map(lambda x: x * x, [1, 2, 3, 4, 5]))
# or
sum(map(lambda x: x ** 2, [1, 2, 3, 4, 5]))
# or
sum(map(lambda x: pow(x, 2), [1, 2, 3, 4, 5]))

# using pow and repeat
from itertools import repeat
sum(map(pow, [1, 2, 3, 4, 5], repeat(2)))

# using starmap and mul
from itertools import starmap
from operator import mul
a = [1, 2, 3, 4, 5]
sum(starmap(mul, zip(a, a)))

# using reduce
from functools import reduce
powers_of_two = (x * x for x in [1, 2, 3, 4, 5])
reduce(lambda x, y : x + y, powers_of_two)
# or
from operator import add
powers_of_two = (x * x for x in [1, 2, 3, 4, 5])
reduce(add, powers_of_two)
# or using a bit more complex lambda
reduce(lambda a, x: a + x*x, [1, 2, 3, 4, 5])
