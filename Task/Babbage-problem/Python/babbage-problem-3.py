from itertools import accumulate, count

print(*next(filter(lambda t: t[1] % 1000000 == 269696, enumerate(accumulate(count(1, 2)), 1))))
