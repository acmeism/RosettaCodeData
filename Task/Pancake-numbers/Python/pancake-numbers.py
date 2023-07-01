"""Pancake numbers. Requires Python>=3.7."""
import time

from collections import deque
from operator import itemgetter
from typing import Tuple

Pancakes = Tuple[int, ...]


def flip(pancakes: Pancakes, position: int) -> Pancakes:
    """Flip the stack of pancakes at the given position."""
    return tuple([*reversed(pancakes[:position]), *pancakes[position:]])


def pancake(n: int) -> Tuple[Pancakes, int]:
    """Return the nth pancake number."""
    init_stack = tuple(range(1, n + 1))
    stack_flips = {init_stack: 0}
    queue = deque([init_stack])

    while queue:
        stack = queue.popleft()
        flips = stack_flips[stack] + 1

        for i in range(2, n + 1):
            flipped = flip(stack, i)
            if flipped not in stack_flips:
                stack_flips[flipped] = flips
                queue.append(flipped)

    return max(stack_flips.items(), key=itemgetter(1))


if __name__ == "__main__":
    start = time.time()

    for n in range(1, 10):
        pancakes, p = pancake(n)
        print(f"pancake({n}) = {p:>2}. Example: {list(pancakes)}")

    print(f"\nTook {time.time() - start:.3} seconds.")
