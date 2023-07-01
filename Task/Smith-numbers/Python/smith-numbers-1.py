from sys import stdout


def factors(n):
    rt = []
    f = 2
    if n == 1:
        rt.append(1);
    else:
        while 1:
            if 0 == ( n % f ):
                rt.append(f);
                n //= f
                if n == 1:
                    return rt
            else:
                f += 1
    return rt


def sum_digits(n):
    sum = 0
    while n > 0:
        m = n % 10
        sum += m
        n -= m
        n //= 10

    return sum


def add_all_digits(lst):
    sum = 0
    for i in range (len(lst)):
        sum += sum_digits(lst[i])

    return sum


def list_smith_numbers(cnt):
    for i in range(4, cnt):
        fac = factors(i)
        if len(fac) > 1:
            if sum_digits(i) == add_all_digits(fac):
                stdout.write("{0} ".format(i) )

# entry point
list_smith_numbers(10_000)
