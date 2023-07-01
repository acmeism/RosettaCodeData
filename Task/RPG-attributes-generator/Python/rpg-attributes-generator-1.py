import random
random.seed()
attributes_total = 0
count = 0

while attributes_total < 75 or count < 2:
    attributes = []

    for attribute in range(0, 6):
        rolls = []

        for roll in range(0, 4):
            result = random.randint(1, 6)
            rolls.append(result)

        sorted_rolls = sorted(rolls)
        largest_3 = sorted_rolls[1:]
        rolls_total = sum(largest_3)

        if rolls_total >= 15:
            count += 1

        attributes.append(rolls_total)

    attributes_total = sum(attributes)

print(attributes_total, attributes)
