class Final(type):
    def __new__(cls, name, bases, classdict):
        for b in bases:
            if isinstance(b, Final):
                raise TypeError(f'Cannot inherit from {b.__name__}')

        return type.__new__(cls, name, bases, classdict)

class FinalClass(metaclass=Final):
    pass

class Random(FinalClass): # will result in an error
    pass
