class Outer:
    __m_private_field: int

    def __init__(self, val = 0):
        self.__m_private_field = val

    class Inner:
        __m_inner_value: int

        def __init__(self, val = 0):
            self.__m_inner_value = val

        def add_outer(self, outer: 'Outer'):
            return self.__m_inner_value + outer._Outer__m_private_field # __m_private_field gets mangled to _Outer__m_private_field

def main():
    outer = Outer(1)
    inner = Outer.Inner(6)

    res = inner.add_outer(outer)
    print(res)

if __name__ == '__main__':
    main()
