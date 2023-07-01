from typing import List


def partitions(n: int) -> int:
    """Count partitions."""
    p: List[int] = [1] + [0] * n
    for i in range(1, n + 1):
        k: int = 0
        while True:
            k += 1
            j: int = (k * (3*k - 1)) // 2
            if (j > i):
                break
            if (k & 1):
                p[i] += p[i - j]
            else:
                p[i] -= p[i - j]
            j = (k * (3*k + 1)) // 2
            if (j > i):
                break
            if (k & 1):
                p[i] += p[i - j]
            else:
                p[i] -= p[i - j]

    return p[n]


if __name__ == '__main__':
    print("\nPartitions:", [partitions(x) for x in range(15)])
