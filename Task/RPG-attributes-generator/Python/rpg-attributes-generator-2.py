import random
random.seed()
total = 0
count = 0

while total < 75 or count < 2:
    attributes = [(sum(sorted([random.randint(1, 6) for roll in range(0, 4)])[1:])) for attribute in range(0, 6)]

    for attribute in attributes:
        if attribute >= 15:
            count += 1

    total = sum(attributes)

print(total, attributes)
