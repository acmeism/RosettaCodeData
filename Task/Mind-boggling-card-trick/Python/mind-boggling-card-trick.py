import random

## 1. Cards
n = 52
Black, Red = 'Black', 'Red'
blacks = [Black] * (n // 2)
reds = [Red] * (n // 2)
pack = blacks + reds
# Give the pack a good shuffle.
random.shuffle(pack)

## 2. Deal from the randomised pack into three stacks
black_stack, red_stack, discard = [], [], []
while pack:
    top = pack.pop()
    if top == Black:
        black_stack.append(pack.pop())
    else:
        red_stack.append(pack.pop())
    discard.append(top)
print('(Discards:', ' '.join(d[0] for d in discard), ')\n')

## 3. Swap the same, random, number of cards between the two stacks.
# We can't swap more than the number of cards in a stack.
max_swaps = min(len(black_stack), len(red_stack))
# Randomly choose the number of cards to swap.
swap_count = random.randint(0, max_swaps)
print('Swapping', swap_count)
# Randomly choose that number of cards out of each stack to swap.
def random_partition(stack, count):
    "Partition the stack into 'count' randomly selected members and the rest"
    sample = random.sample(stack, count)
    rest = stack[::]
    for card in sample:
        rest.remove(card)
    return rest, sample

black_stack, black_swap = random_partition(black_stack, swap_count)
red_stack, red_swap = random_partition(red_stack, swap_count)

# Perform the swap.
black_stack += red_swap
red_stack += black_swap

## 4. Order from randomness?
if black_stack.count(Black) == red_stack.count(Red):
    print('Yeha! The mathematicians assertion is correct.')
else:
    print('Whoops - The mathematicians (or my card manipulations) are flakey')
