# Contents of `pip install compositions'

class Compose(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, x):
        return self.func(x)

    def __mul__(self, neighbour):
        return Compose(lambda x: self.func(neighbour.func(x)))

# from composition.composition import Compose
if __name__ == "__main__":
    # Syntax 1
    @Compose
    def f(x):
        return x

    # Syntax 2
    g = Compose(lambda x: x)

    print((f * g)(2))
