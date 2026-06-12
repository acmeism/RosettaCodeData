"""Find common list elements using collections.Counter (multiset)."""

from collections import Counter
from functools import reduce
from itertools import chain


def common_list_elements(*lists):
    counts = (Counter(list_) for list_ in lists)
    intersection = reduce(lambda x, y: x & y, counts)
    return list(chain.from_iterable([elem] * cnt for elem, cnt in intersection.items()))


if __name__ == "__main__":
    test_cases = [
        ([2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]),
        ([2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]),
    ]

    for case in test_cases:
        result = common_list_elements(*case)
        print(f"Intersection of {case} is {result}")
