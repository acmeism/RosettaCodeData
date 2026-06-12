import random
from itertools import product

def riffleShuffle(va, flips):
    nl = va
    for _ in range(flips):
        #cut the deck at the middle +/- 10%, remove the second line of the formula for perfect cutting
        cutPoint = len(nl) // 2 + random.choice([-1, 1]) * random.randint(0, len(va) // 10)

        # split the deck
        left = nl[0:cutPoint]
        right = nl[cutPoint:]

        del nl[:]
        while (len(left) > 0 and len(right) > 0):
            #allow for imperfect riffling so that more than one card can come from the same side in a row
            #biased towards the side with more cards
            #remove the if and else and brackets for perfect riffling
            if (random.uniform(0, 1) >= len(left) / len(right) / 2):
                nl.append(right.pop(0))
            else:
                nl.append(left.pop(0))
        if (len(left) > 0):
            nl += left
        if (len(right) > 0):
            nl += right
    return nl

def overhandShuffle(va, passes):
    mainHand = va
    for _ in range(passes):
        otherHand = []
        while (len(mainHand) > 0):
            #cut at up to 20% of the way through the deck
            cutSize = random.randint(0, len(va) // 5) + 1
            temp = []

            #grab the next cut up to the end of the cards left in the main hand
            i = 0
            while (i < cutSize and len(mainHand) > 0):
                temp.append(mainHand.pop(0))
                i += 1

            #add them to the cards in the other hand, sometimes to the front sometimes to the back
            if (random.uniform(0, 1) >= 0.1):
                #front most of the time
                otherHand = temp + otherHand
            else:
                otherHand += temp
        #move the cards back to the main hand
        mainHand = otherHand
    return mainHand

def shuffler(name, iters = 0):
    nums = list(range(1, 21))
    print(f"{name} shuffle", "" if name == "Library" else f"({iters} iteration(s))")
    print(nums)
    match name:
        case "Riffle":
            print(riffleShuffle(nums, iters))
        case "Overhand":
            print(overhandShuffle(nums, iters))
        case "Library":
            random.shuffle(nums)
            print(nums)
    print()

for s, n in product(["Riffle", "Overhand"], [10, 1]):
    shuffler(s, n)

shuffler("Library")
