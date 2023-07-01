# -*- coding: utf-8 -*-

# Unicode: 9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608
bar = '▁▂▃▄▅▆▇█'
barcount = len(bar)

def sparkline(numbers):
    mn, mx = min(numbers), max(numbers)
    extent = mx - mn
    sparkline = ''.join(bar[min([barcount - 1,
                                 int((n - mn) / extent * barcount)])]
                        for n in numbers)
    return mn, mx, sparkline

if __name__ == '__main__':
    import re

    for line in ("0 0 1 1; 0 1 19 20; 0 999 4000 4999 7000 7999;"
                 "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1;"
                 "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5 ").split(';'):
        print("\nNumbers:", line)
        numbers = [float(n) for n in re.split(r'[\s,]+', line.strip())]
        mn, mx, sp = sparkline(numbers)
        print('  min: %5f; max: %5f' % (mn, mx))
        print("  " + sp)
