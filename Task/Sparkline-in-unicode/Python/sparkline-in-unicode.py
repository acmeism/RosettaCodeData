import re
try: raw_input
except: raw_input = input

# Unicode: 9601, 9602, 9603, 9604, 9605, 9606, 9607, 9608
try: bar = u'▁▂▃▄▅▆▇█'
except: bar = '▁▂▃▄▅▆▇█'
barcount = len(bar) - 1
while True:
    line = raw_input('Numbers please separated by space/commas: ')
    numbers = [float(n) for n in re.split(r'[\s,]+', line.strip())]
    mn, mx = min(numbers), max(numbers)
    extent = mx - mn
    sparkline = ''.join(bar[int( (n - mn) / extent * barcount)]
                        for n in numbers)
    print('min: %5f; max: %5f' % (mn, mx))
    print(sparkline)
