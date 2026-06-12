import Foundation

class WaveletMatrixDemo {
    // BitRank is a rank data structure for bit vectors
    class BitRank {
        private var block: [UInt64] = []
        private var count: [Int] = []

        // Resize resizes the bit vector to the given length
        func resize(_ num: Int) {
            block = Array(repeating: 0, count: ((num + 1) >> 6) + 1)
            count = Array(repeating: 0, count: block.count)
        }

        // Set sets bit at position i
        func set(_ i: Int, _ val: Int) {
            if val == 1 {
                block[i >> 6] |= (1 << (i & 63))
            }
        }

        // Build builds the rank structure
        func build() {
            for i in 1..<block.count {
                count[i] = count[i - 1] + popcountll(block[i - 1])
            }
        }

        // popcountll counts number of 1's in a 64-bit integer
        private func popcountll(_ n: UInt64) -> Int {
            return n.nonzeroBitCount
        }

        // Rank1 counts number of 1's in [0, i)
        func rank1(_ i: Int) -> Int {
            return count[i >> 6] + popcountll(block[i >> 6] & ((1 << (i & 63)) - 1))
        }

        // Rank1FromTo counts number of 1's in [i, j)
        func rank1FromTo(_ i: Int, _ j: Int) -> Int {
            return rank1(j) - rank1(i)
        }

        // Rank0 counts number of 0's in [0, i)
        func rank0(_ i: Int) -> Int {
            return i - rank1(i)
        }

        // Rank0FromTo counts number of 0's in [i, j)
        func rank0FromTo(_ i: Int, _ j: Int) -> Int {
            return rank0(j) - rank0(i)
        }
    }

    // WaveletMatrix is a wavelet matrix data structure
    class WaveletMatrix {
        private var height: Int = 0
        private var B: [BitRank] = []
        private var pos: [Int] = []

        // Constructor creates a new wavelet matrix
        init(_ vec: [Int], _ sigma: Int...) {
            var s = 0
            if !sigma.isEmpty {
                s = sigma[0]
            } else {
                // Find the maximum element and use that as sigma
                for v in vec {
                    if v > s {
                        s = v
                    }
                }
                s += 1
            }

            initialize(vec, s)
        }

        private func initialize(_ vec: [Int], _ sigma: Int) {
            // Calculate height based on sigma value
            if sigma == 1 {
                height = 1
            } else {
                height = 64 - sigma.leadingZeroBitCount - 1
            }

            B = Array(repeating: BitRank(), count: height)
            pos = Array(repeating: 0, count: height)

            var vecCopy = vec

            for i in 0..<height {
                B[i] = BitRank()
                B[i].resize(vecCopy.count)

                for j in 0..<vecCopy.count {
                    B[i].set(j, get(vecCopy[j], height - i - 1))
                }

                B[i].build()

                // Use stablePartition to sort the array
                pos[i] = stablePartition(&vecCopy) { get($0, height - i - 1) == 0 }
            }
        }

        // stablePartition is equivalent to C++ stable_partition
        private func stablePartition<T>(_ arr: inout [T], _ predicate: (T) -> Bool) -> Int {
            var result: [T] = []
            var falseValues: [T] = []

            for item in arr {
                if predicate(item) {
                    result.append(item)
                } else {
                    falseValues.append(item)
                }
            }

            let partitionPoint = result.count
            result.append(contentsOf: falseValues)

            // Update the original array
            arr = result

            return partitionPoint
        }

        // get returns bit at position i from val
        private func get(_ val: Int, _ i: Int) -> Int {
            return (val >> i) & 1
        }

        // Rank counts occurrences of val in range [l, r)
        func rank(_ val: Int, _ l: Int, _ r: Int) -> Int {
            return rankSingle(val, r) - rankSingle(val, l)
        }

        // RankSingle counts occurrences of val in range [0, i)
        func rankSingle(_ val: Int, _ i: Int) -> Int {
            var p = 0
            var idx = i

            for j in 0..<height {
                if get(val, height - j - 1) == 1 {
                    p = pos[j] + B[j].rank1(p)
                    idx = pos[j] + B[j].rank1(idx)
                } else {
                    p = B[j].rank0(p)
                    idx = B[j].rank0(idx)
                }
            }
            return idx - p
        }

        // Quantile returns kth smallest element in [l, r)
        func quantile(_ k: Int, _ l: Int, _ r: Int) -> Int {
            var res = 0
            var left = l
            var right = r
            var kValue = k

            for i in 0..<height {
                let j = B[i].rank0FromTo(left, right)
                if j > kValue {
                    left = B[i].rank0(left)
                    right = B[i].rank0(right)
                } else {
                    left = pos[i] + B[i].rank1(left)
                    right = pos[i] + B[i].rank1(right)
                    kValue -= j
                    res |= (1 << (height - i - 1))
                }
            }
            return res
        }

        // RangeFreq counts elements in [l, r) that are in value range [a, b)
        func rangeFreq(_ l: Int, _ r: Int, _ a: Int, _ b: Int) -> Int {
            return rangeFreqRecursive(l, r, a, b, 0, 1 << height, 0)
        }

        private func rangeFreqRecursive(_ i: Int, _ j: Int, _ a: Int, _ b: Int, _ l: Int, _ r: Int, _ x: Int) -> Int {
            if i == j || r <= a || b <= l {
                return 0
            }

            let mid = (l + r) >> 1
            if a <= l && r <= b {
                return j - i
            } else {
                let left = rangeFreqRecursive(
                    B[x].rank0(i),
                    B[x].rank0(j),
                    a, b, l, mid, x + 1
                )
                let right = rangeFreqRecursive(
                    pos[x] + B[x].rank1(i),
                    pos[x] + B[x].rank1(j),
                    a, b, mid, r, x + 1
                )
                return left + right
            }
        }

        // RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
        func rangeMin(_ l: Int, _ r: Int, _ a: Int, _ b: Int) -> Int {
            return rangeMinRecursive(l, r, a, b, 0, 1 << height, 0, 0)
        }

        private func rangeMinRecursive(_ i: Int, _ j: Int, _ a: Int, _ b: Int, _ l: Int, _ r: Int, _ x: Int, _ val: Int) -> Int {
            if i == j || r <= a || b <= l {
                return -1
            }
            if r - l == 1 {
                return val
            }

            let mid = (l + r) >> 1
            let res = rangeMinRecursive(
                B[x].rank0(i),
                B[x].rank0(j),
                a, b, l, mid, x + 1, val
            )

            if res < 0 {
                return rangeMinRecursive(
                    pos[x] + B[x].rank1(i),
                    pos[x] + B[x].rank1(j),
                    a, b, mid, r, x + 1,
                    val + (1 << (height - x - 1))
                )
            } else {
                return res
            }
        }
    }

    // binary search to find index in sorted array
    static func find(_ arr: [Int], _ x: Int) -> Int {
        var left = 0
        var right = arr.count
        while left < right {
            let mid = (left + right) / 2
            if arr[mid] < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }

    static func main() {
        let n = 5
        let a = [3374, 956, 2114, 3415, 3437]

        var input = Array(a[0..<n])
        let backup = Array(a[0..<n])

        // Sort and deduplicate the array
        var sortedA = Array(a[0..<n])
        sortedA.sort()

        // Deduplicate
        var uniqueAList: [Int] = []
        for i in 0..<sortedA.count {
            if i == 0 || sortedA[i] != sortedA[i - 1] {
                uniqueAList.append(sortedA[i])
            }
        }

        let uniqueA = uniqueAList

        // Map original values to their indices in the unique array
        for i in 0..<n {
            input[i] = find(uniqueA, backup[i])
        }

        let lrkVector = [
            [2, 2, 1],
            [3, 4, 1],
            [4, 5, 1],
            [1, 2, 2],
            [4, 4, 1]
        ]

        let wm = WaveletMatrix(input)

        for lrk in lrkVector {
            var l = lrk[0]
            let r = lrk[1]
            let k = lrk[2]
            l -= 1 // Convert to 0-indexed
            print(uniqueA[wm.quantile(k - 1, l, r)])
        }
    }
}

// Run the demo
WaveletMatrixDemo.main()
