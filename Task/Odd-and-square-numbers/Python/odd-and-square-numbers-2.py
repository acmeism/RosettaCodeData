from itertools import accumulate, count, dropwhile, takewhile

print(*takewhile(lambda x: x<1000, dropwhile(lambda x: x<100, accumulate(count(8, 8), initial=1))))
