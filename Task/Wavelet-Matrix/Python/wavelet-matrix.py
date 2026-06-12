import math


class BitRank:
    def __init__(self):
        self.block = []
        self.count = []

    def resize(self, num):
        self.block = [0] * (math.floor((num + 1) >> 6) + 1)
        self.count = [0] * len(self.block)

    def set(self, i, val):
        self.block[i >> 6] |= (val << (i & 63))

    def build(self):
        for i in range(1, len(self.block)):
            self.count[i] = self.count[i - 1] + \
                self.popcountll(self.block[i - 1])

    def popcountll(self, n):
        count = 0
        while n:
            count += n & 1
            n >>= 1
        return count

    def rank1(self, i):
        return self.count[i >> 6] + self.popcountll(self.block[i >> 6] & ((1 << (i & 63)) - 1))

    def rank1FromTo(self, i, j):
        return self.rank1(j) - self.rank1(i)

    def rank0(self, i):
        return i - self.rank1(i)

    def rank0FromTo(self, i, j):
        return self.rank0(j) - self.rank0(i)


class WaveletMatrix:
    def __init__(self, vec, sigma=None):
        if sigma is None:
            sigma = max(vec) + 1
        self.init(vec, sigma)

    def init(self, vec, sigma):
        # Calculate height based on sigma value
        self.height = 1 if sigma == 1 else (64 - (sigma - 1).bit_length() + 1)
        self.B = [None] * self.height
        self.pos = [0] * self.height

        for i in range(self.height):
            self.B[i] = BitRank()
            self.B[i].resize(len(vec))

            for j in range(len(vec)):
                self.B[i].set(j, self.get(vec[j], self.height - i - 1))

            self.B[i].build()

            # Stable partition
            partition = self.stable_partition(
                vec, lambda c: not self.get(c, self.height - i - 1))
            self.pos[i] = partition

    def stable_partition(self, arr, predicate):
        result = []
        false_values = []

        for item in arr:
            if predicate(item):
                result.append(item)
            else:
                false_values.append(item)

        partition_point = len(result)
        result.extend(false_values)

        # Update the original array
        for i in range(len(arr)):
            arr[i] = result[i]

        return partition_point

    def get(self, val, i):
        return (val >> i) & 1

    def rank(self, val, l, r=None):
        if r is None:
            return self.rank_single(val, l)
        return self.rank_single(val, r) - self.rank_single(val, l)

    def rank_single(self, val, i):
        p = 0
        for j in range(self.height):
            if self.get(val, self.height - j - 1):
                p = self.pos[j] + self.B[j].rank1(p)
                i = self.pos[j] + self.B[j].rank1(i)
            else:
                p = self.B[j].rank0(p)
                i = self.B[j].rank0(i)
        return i - p

    def quantile(self, k, l, r):
        res = 0
        for i in range(self.height):
            j = self.B[i].rank0FromTo(l, r)
            if j > k:
                l = self.B[i].rank0(l)
                r = self.B[i].rank0(r)
            else:
                l = self.pos[i] + self.B[i].rank1(l)
                r = self.pos[i] + self.B[i].rank1(r)
                k -= j
                res |= (1 << (self.height - i - 1))
        return res

    def rangefreq(self, l, r, a, b):
        return self.rangefreq_recursive(l, r, a, b, 0, 1 << self.height, 0)

    def rangefreq_recursive(self, i, j, a, b, l, r, x):
        if i == j or r <= a or b <= l:
            return 0
        mid = (l + r) >> 1
        if a <= l and r <= b:
            return j - i
        left = self.rangefreq_recursive(
            self.B[x].rank0(i),
            self.B[x].rank0(j),
            a, b, l, mid, x + 1
        )
        right = self.rangefreq_recursive(
            self.pos[x] + self.B[x].rank1(i),
            self.pos[x] + self.B[x].rank1(j),
            a, b, mid, r, x + 1
        )
        return left + right

    def rangemin(self, l, r, a, b):
        return self.rangemin_recursive(l, r, a, b, 0, 1 << self.height, 0, 0)

    def rangemin_recursive(self, i, j, a, b, l, r, x, val):
        if i == j or r <= a or b <= l:
            return -1
        if r - l == 1:
            return val

        mid = (l + r) >> 1
        res = self.rangemin_recursive(
            self.B[x].rank0(i),
            self.B[x].rank0(j),
            a, b, l, mid, x + 1, val
        )

        if res < 0:
            return self.rangemin_recursive(
                self.pos[x] + self.B[x].rank1(i),
                self.pos[x] + self.B[x].rank1(j),
                a, b, mid, r, x + 1,
                val + (1 << (self.height - x - 1))
            )
        return res


def main():
    n = 5
    a = [3374, 956, 2114, 3415, 3437]

    input_arr = a.copy()
    backup = a.copy()

    # Sort and deduplicate the array
    sorted_a = sorted(a)
    unique_a = list(dict.fromkeys(sorted_a))

    def find(x):
        left, right = 0, len(unique_a)
        while left < right:
            mid = (left + right) // 2
            if unique_a[mid] < x:
                left = mid + 1
            else:
                right = mid
        return left

    # Map original values to their indices in the unique array
    for i in range(n):
        input_arr[i] = find(backup[i])

    lrk_vector = [[2, 2, 1], [3, 4, 1], [4, 5, 1], [1, 2, 2], [4, 4, 1]]

    wm = WaveletMatrix(input_arr)

    for l, r, k in lrk_vector:
        l -= 1  # Convert to 0-indexed
        print(unique_a[wm.quantile(k - 1, l, r)])


if __name__ == "__main__":
    main()
