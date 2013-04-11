def maxnum(x):
    maxlen = len(str(max(x)))
    return ''.join(sorted((str(v) for v in x), reverse=True,
                          key=lambda i: i*(maxlen * 2 // len(i))))

for numbers in [(212, 21221), (1, 34, 3, 98, 9, 76, 45, 4), (54, 546, 548, 60)]:
    print('Numbers: %r' % (numbers, maxnum(numbers)))
