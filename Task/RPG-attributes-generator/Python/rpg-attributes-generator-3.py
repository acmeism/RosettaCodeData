import random

def compute():
    values = []
    while (sum(values) < 75                            # Total must be >= 75
           or sum(1 for v in values if v >= 15) < 2):  # Two must be >= 15
        values = [sum(sorted(random.randint(1, 6) for _ in range(4))[1:]) for _ in range(6)]
    return sum(values), values

for i in range(3):
    print(*compute())
