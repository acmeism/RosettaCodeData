from fractions import Fraction
from decimal import Decimal, getcontext
getcontext().prec = 60
from itertools import product

casting_functions = [int, float, complex,   # Numbers
                     Fraction, Decimal,     # Numbers
                     hex, oct, bin,         # Int representations - not strictly types
                     bool,                  # Boolean/integer Number
                     iter,                  # Iterator type
                     list, tuple, range,    # Sequence types
                     str, bytes,            # Strings, byte strings
                     bytearray,             # Mutable bytes
                     set, frozenset,        # Set, hashable set
                     dict,                  # hash mapping dictionary
                    ]

examples_of_types = [0, 42,
                     0.0 -0.0, 12.34, 56.0,
                     (0+0j), (1+2j), (1+0j), (78.9+0j), (0+1.2j),
                     Fraction(0, 1), Fraction(22, 7), Fraction(4, 2),
                     Decimal('0'),
                     Decimal('3.14159265358979323846264338327950288419716939937510'),
                     Decimal('1'), Decimal('1.5'),
                     True, False,
                     iter(()), iter([1, 2, 3]), iter({'A', 'B', 'C'}),
                     iter([[1, 2], [3, 4]]), iter((('a', 1), (2, 'b'))),
                     [], [1, 2], [[1, 2], [3, 4]],
                     (), (1, 'two', (3+0j)), (('a', 1), (2, 'b')),
                     range(0), range(3),
                     "", "A", "ABBA", "Milü",
                     b"", b"A", b"ABBA",
                     bytearray(b""), bytearray(b"A"), bytearray(b"ABBA"),
                     set(), {1, 'two', (3+0j), (4, 5, 6)},
                     frozenset(), frozenset({1, 'two', (3+0j), (4, 5, 6)}),
                     {}, {1: 'one', 'two': (2+3j), ('RC', 3): None}
                    ]
if __name__ == '__main__':
    print('Common Python types/type casting functions:')
    print('  ' + '\n  '.join(f.__name__ for f in casting_functions))
    print('\nExamples of those types:')
    print('  ' + '\n  '.join('%-26s %r' % (type(e), e) for e in examples_of_types))
    print('\nCasts of the examples:')
    for f, e in product(casting_functions, examples_of_types):
        try:
            ans = f(e)
        except BaseException:
            ans = 'EXCEPTION RAISED!'
        print('%-60s -> %r' % ('%s(%r)' % (f.__name__, e), ans))
