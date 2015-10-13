MULTIPLY = lambda x, y: x*y

class num(float):
    # the following method has complexity O(b)
    # rather than O(log b) via the rapid exponentiation
    def __pow__(self, b):
        return reduce(MULTIPLY, [self]*b, 1)

# works with ints as function or operator
print num(2).__pow__(3)
print num(2) ** 3

# works with floats as function or operator
print num(2.3).__pow__(8)
print num(2.3) ** 8
