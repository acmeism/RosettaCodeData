tutor = True

from itertools import izip, takewhile

def iterate(function, arg):
    while 1:
        yield arg
        arg = function(arg)

def halve(x): return x // 2
def double(x): return x * 2
def even(x): return x % 2 == 0

def show_heading(multiplier, multiplicand):
    print "Multiplying %d by %d" % (multiplier, multiplicand),
    print "using Ethiopian multiplication:"
    print

TABLE_FORMAT = "%8s %8s %8s %8s %8s"

def show_table(table):
    for p, q in table:
        print TABLE_FORMAT % (p, q, "->",
                              p, q if not even(p) else "-" * len(str(q)))

def show_result(result):
    print TABLE_FORMAT % ('', '', '', '', "=" * (len(str(result)) + 1))
    print TABLE_FORMAT % ('', '', '', '', result)

def ethiopian(multiplier, multiplicand):
    def column1(x): return takewhile(lambda v: v >= 1, iterate(halve, x))
    def column2(x): return iterate(double, x)
    def rows(x, y): return izip(column1(x), column2(y))
    table = rows(multiplier, multiplicand)
    if tutor:
        table = list(table)
        show_heading(multiplier, multiplicand)
        show_table(table)
    result = sum(q for p, q in table if not even(p))
    if tutor:
        show_result(result)
    return result
