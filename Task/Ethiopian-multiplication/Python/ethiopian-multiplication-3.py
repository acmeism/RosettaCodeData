tutor = True

from itertools import takewhile

def iterate(function, arg):
    while True:
        yield arg
        arg = function(arg)

halve = lambda x: x // 2
double = lambda x: x * 2
even = lambda x: x % 2 == 0

def show_heading(multiplier, multiplicand):
    print("Multiplying %d by %d" % (multiplier, multiplicand), end = " ")
    print("using Ethiopian multiplication:")
    print()

TABLE_FORMAT = "%8s %8s %8s %8s %8s"

def show_table(table):
    for p, q in table:
        print(TABLE_FORMAT % (p, q, "->",
                              p, q if not even(p) else "-" * len(str(q))))

def show_result(result):
    print(TABLE_FORMAT % ('', '', '', '', "=" * (len(str(result)) + 1)))
    print(TABLE_FORMAT % ('', '', '', '', result))

def ethiopian(multiplier, multiplicand):
    column1 = lambda x: takewhile(lambda v: v >= 1, iterate(halve, x))
    column2 = lambda x: iterate(double, x)
    rows = lambda x, y: zip(column1(x), column2(y))
    table = rows(multiplier, multiplicand)
    if tutor:
        table = list(table)
        show_heading(multiplier, multiplicand)
        show_table(table)
    result = sum(q for p, q in table if not even(p))
    if tutor:
        show_result(result)
    return result

print(ethiopian(17, 34))
