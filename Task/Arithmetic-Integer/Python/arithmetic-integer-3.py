def arithmetic(x, y):
    for op in "+ - * // % **".split():
        expr = "%(x)s %(op)s %(y)s" % vars()
        print("%s\t=> %s" % (expr, eval(expr)))


arithmetic(12, 8)
arithmetic(input("Number 1: "), input("Number 2: "))
