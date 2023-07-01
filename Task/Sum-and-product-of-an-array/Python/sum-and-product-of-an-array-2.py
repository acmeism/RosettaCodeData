from operator import mul, add
sum = reduce(add, numbers) # note: this version doesn't work with empty lists
sum = reduce(add, numbers, 0)
product = reduce(mul, numbers) # note: this version doesn't work with empty lists
product = reduce(mul, numbers, 1)
