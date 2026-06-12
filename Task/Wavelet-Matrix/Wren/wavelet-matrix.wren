import "./long" for ULong
import "./math" for Nums
import "./fmt" for Conv
import "./seq" for Lst

// Returns the number of leading zeros in a 32 bit binary number.
var Clz32 = Fn.new { |d|
    var b = Conv.itoa(d, 2)
    return 32 - b.trimStart("0").count
}

class BitRank {
    construct new() {
        _block = []
        _count = []
    }

    // Resize the bit vector to the given length.
    resize(num) {
        var len = ((num + 1) >> 6).floor + 1
        _block = List.filled(len, null)
        for (i in 0...len) _block[i] = ULong.zero
        _count = List.filled(len, 0)
    }

    // Set bit at position i.
    set(i, val) {
        _block[i >> 6] = _block[i >> 6] | (ULong.new(val) << ULong.new(i & 63))
    }

    // Build the rank structure.
    build() {
        for (i in 1..._block.count) _count[i] = count[i-1] + popcountll(_block[i-1])
    }

    // Count number of 1's in a 64-bit integer (popcount equivalent).
    popcountll(n) {
        var count = 0
        while (n != ULong.zero) {
            count = count + (n & ULong.one).toSmall
            n = n >> ULong.one
        }
        return count
    }

    // Count number of 1's in [0, i).
    rank1(i) {
        return _count[i >> 6] + popcountll(_block[i >> 6] & ((ULong.one << ULong.new(i & 63)) - ULong.one))
    }

    // Count number of 1's in [i, j).
    rank1FromTo(i, j) { rank1(j) - rank1(i) }

    // Count number of 0's in [0, i).
    rank0(i) { i - rank1(i) }

    // Count number of 0's in [i, j).
    rank0FromTo(i, j) { rank0(j) - rank0(i) }
}

class WaveletMatrix {
    construct new(vec, sigma) {
        if (!sigma) {
            // Find the maximum element and use that as sigma.
            sigma = Nums.max(vec) + 1
        }
        init(vec, sigma)
    }

    init(vec, sigma) {
        // Calculate height based on sigma value.
        _height = (sigma == 1) ? 1 : (64 - Clz32.call(sigma - 1))
        _B = List.filled(_height, 0)
        _pos = List.filled(_height, 0)

        for (i in 0..._height) {
            _B[i] = BitRank.new()
            _B[i].resize(vec.count)

            for (j in 0...vec.count) {
                _B[i].set(j, get(vec[j], _height - i - 1))
            }

            _B[i].build()

            // Stable partition - separate 0's and 1's while preserving order.
            var partition = stablePartition(vec) { |c| get(c, _height - i - 1) == 0 }
            _pos[i] = partition
        }
    }

    // Stable partition implementation.
    stablePartition(arr, predicate) {
        var result = []
        var falseValues = []

        for (item in arr) {
            if (predicate.call(item)) {
                result.add(item)
            } else {
                falseValues.add(item)
            }
        }

        var partitionPoint = result.count
        result.addAll(falseValues)

        // Update the original array.
        for (i in 0...arr.count) arr[i] = result[i]

        return partitionPoint
    }

    // Get bit at position i from val.
    get(val, i) {
        return (val >> i) & 1
    }

    // Count occurrences of val in range [l, r).
    rank(val, l, r) {
        if (!r) {
            // Single parameter version: [0, l).
            return rankSingle(val, l)
        }
        return rankSingle(val, r) - rankSingle(val, l)
    }

    // Count occurrences of val in range [0, i).
    rankSingle(val, i) {
        var p = 0
        for (j in 0..._height) {
            if (get(val, _height - j - 1) != 0) {
                p = _pos[j] + _B[j].rank1(p)
                i = _pos[j] + _B[j].rank1(i)
            } else {
                p = _B[j].rank0(p)
                i = _B[j].rank0(i)
            }
        }
        return i - p
    }

    // kth smallest element in [l, r)
    quantile(k, l, r) {
        var res = 0
        for (i in 0..._height) {
            var j = _B[i].rank0FromTo(l, r)
            if (j > k) {
                l = _B[i].rank0(l)
                r = _B[i].rank0(r)
            } else {
                l = _pos[i] + _B[i].rank1(l)
                r = _pos[i] + _B[i].rank1(r)
                k = k - j
                res = res | (1 << (_height - i - 1))
            }
        }
        return res
    }

    // Count elements in [l, r) that are in value range [a, b).
    rangefreq(l, r, a, b) {
        return rangefreqRecursive(l, r, a, b, 0, 1 << _height, 0)
    }

    rangefreqRecursive(i, j, a, b, l, r, x) {
        if (i == j || r <= a || b <= l) return 0
        var mid = (l + r) >> 1
        if (a <= l && r <= b) {
            return j - i
        } else {
            var left = rangefreqRecursive(
                _B[x].rank0(i),
                _B[x].rank0(j),
                a, b, l, mid, x + 1
            )
            var right = rangefreqRecursive(
                _pos[x] + _B[x].rank1(i),
                _pos[x] + _B[x].rank1(j),
                a, b, mid, r, x + 1
            )
            return left + right
        }
    }

    // Find minimum value in [l, r) within value range [a, b), -1 if not found.
    rangemin(l, r, a, b) {
        return rangeminRecursive(l, r, a, b, 0, 1 << _height, 0, 0)
    }

    rangeminRecursive(i, j, a, b, l, r, x, val) {
        if (i == j || r <= a || b <= l) return -1
        if (r - l == 1) return val

        var mid = (l + r) >> 1
        var res = rangeminRecursive(
            _B[x].rank0(i),
            _B[x].rank0(j),
            a, b, l, mid, x + 1, val
        )

        if (res < 0) {
            return this.rangeminRecursive(
                _pos[x] + _B[x].rank1(i),
                _pos[x] + _B[x].rank1(j),
                a, b, mid, r, x + 1,
                val + (1 << (_height - x - 1))
            )
        } else {
            return res
        }
    }
}

var n = 5
var q = 5
var a = [3374, 956, 2114, 3415, 3437]

var input = a.toList
var backup = a.toList

// Sort and deduplicate the array.
var sortedA = a.toList.sort()
var uniqueA = Lst.distinct(sortedA)

// Function to find index of an element in the unique array.
var find = Fn.new { |x|
    var left = 0
    var right = uniqueA.count
    while (left < right) {
        var mid = ((left + right)/2).floor
        if (uniqueA[mid] < x) {
            left = mid + 1
        } else {
            right = mid
        }
    }
    return left
}

// Map original values to their indices in the unique array.
for (i in 0...n) {
    input[i] = find.call(backup[i])
}

var lrkVector = [[2, 2, 1], [3, 4, 1], [4, 5, 1], [1, 2, 2], [4, 4, 1]]
var wm = WaveletMatrix.new(input, null)

for (lrk in lrkVector) {
    var l = lrk[0]
    var r = lrk[1]
    var k = lrk[2]
    l = l - 1  // convert to 0-indexed
    System.print(uniqueA[wm.quantile(k - 1, l, r)])
}
