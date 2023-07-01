import random
from typing import List, Callable, Optional


def modifier(x: float) -> float:
    """
    V-shaped, modifier(x) goes from 1 at 0 to 0 at 0.5 then back to 1 at 1.0 .

    Parameters
    ----------
    x : float
        Number, 0.0 .. 1.0 .

    Returns
    -------
    float
        Target probability for generating x; between 0 and 1.

    """
    return 2*(.5 - x) if x < 0.5 else 2*(x - .5)


def modified_random_distribution(modifier: Callable[[float], float],
                                 n: int) -> List[float]:
    """
    Generate n random numbers between 0 and 1 subject to modifier.

    Parameters
    ----------
    modifier : Callable[[float], float]
        Target random number gen. 0 <= modifier(x) < 1.0 for 0 <= x < 1.0 .
    n : int
        number of random numbers generated.

    Returns
    -------
    List[float]
        n random numbers generated with given probability.

    """
    d: List[float] = []
    while len(d) < n:
        r1 = prob = random.random()
        if random.random() < modifier(prob):
            d.append(r1)
    return d


if __name__ == '__main__':
    from collections import Counter

    data = modified_random_distribution(modifier, 50_000)
    bins = 15
    counts = Counter(d // (1 / bins) for d in data)
    #
    mx = max(counts.values())
    print("   BIN, COUNTS, DELTA: HISTOGRAM\n")
    last: Optional[float] = None
    for b, count in sorted(counts.items()):
        delta = 'N/A' if last is None else str(count - last)
        print(f"  {b / bins:5.2f},  {count:4},  {delta:>4}: "
              f"{'#' * int(40 * count / mx)}")
        last = count
