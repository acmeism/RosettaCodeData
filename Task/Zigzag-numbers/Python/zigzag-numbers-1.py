def is_zigzag(arr):
    """ True if the permutation has the zigzag property """
    if not arr or len(arr) < 2:
        return True
    for i in range(len(arr) - 1):
        if i % 2 == 0: # even index i
            if arr[i] >= arr[i + 1]:
                return False
        else: # odd index i
            if arr[i] <= arr[i + 1]:
                return False
    return True


def next_zigzag_perm(arr):
    """
        Mutates arr into the next permutation with the zigzag property.
        Returns True if a new permutation was found, otherwise False.
    """
    while True:
        if not arr or len(arr) == 1:
            break
        # Find last index where arr[i] < arr[i+1]
        i = -1
        for idx in range(len(arr) - 1):
            if arr[idx] < arr[idx + 1]:
                i = idx
        if i == -1:
            arr[:] = arr[::-1]  # Reverse the array
            break
        # Find last index where arr[j] > arr[i]
        j = i + 1
        for idx in range(i + 1, len(arr)):
            if arr[idx] > arr[i]:
                j = idx
        # Swap elements at i and j
        arr[i], arr[j] = arr[j], arr[i]
        # Reverse the subarray from i+1 to end
        arr[i + 1:] = arr[i + 1:][::-1]
        if is_zigzag(arr):
            return True
    return False


class Zigzags:
    """Lazy iterator to generate zigzag permutations of length n"""

    def __init__(self, n):
        self.n = n
        self.state = list(range(1, self.n + 1))

    def __iter__(self):
        self.state = list(range(1, self.n + 1))
        return self

    def __next__(self):
        if next_zigzag_perm(self.state):
            return self.state[:]
        raise StopIteration


def test_zigzags(n_listings, n_totals):
    """ Generate zigzag permutation listings and print totals. """
    for n in range(1, n_listings + 1):
        print(f"\nZigZag Permutations for N = {n}:")
        if n < 3:
            print(list(range(1, n + 1)))
        else:
            for a in Zigzags(n):
                print(a, end=" ")
            print()

    zzn = [1]
    print("\nN     Zigzags\n--------------------------------\n 1    1")
    for m in range(1, n_totals):
        cumsum = []
        total = 0
        if m % 2 == 0:
            reversed_zzn = zzn[::-1]
            for x in reversed_zzn:
                total += x
                cumsum.append(total)
            zzn = cumsum[::-1] + [0]
        else:
            for x in zzn:
                total += x
                cumsum.append(total)
            zzn = [0] + cumsum
        print(f"{m + 1:2d}    {sum(zzn)}")


if __name__ == "__main__":
    test_zigzags(5, 30)
