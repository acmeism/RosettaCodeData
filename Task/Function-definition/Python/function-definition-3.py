class Multiply:
    def __init__(self):
        pass
    def __call__(self, a, b):
        return a * b

multiply = Multiply()
print multiply(2, 4)    # prints 8
