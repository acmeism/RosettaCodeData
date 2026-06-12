import java.util.ArrayList

class MainKt {
    // BitRank is a rank data structure for bit vectors
    class BitRank {
        private lateinit var block: LongArray
        private lateinit var count: IntArray

        // Resize resizes the bit vector to the given length
        fun resize(num: Int) {
            block = LongArray(((num + 1) shr 6) + 1)
            count = IntArray(block.size)
        }

        // Set sets bit at position i
        fun set(i: Int, value: Int) {
            if (value == 1) {
                block[i shr 6] = block[i shr 6] or (1L shl (i and 63))
            }
        }

        // Build builds the rank structure
        fun build() {
            for (i in 1 until block.size) {
                count[i] = count[i - 1] + popcountll(block[i - 1])
            }
        }

        // popcountll counts number of 1's in a 64-bit integer
        private fun popcountll(n: Long): Int {
            return java.lang.Long.bitCount(n)
        }

        // Rank1 counts number of 1's in [0, i)
        fun rank1(i: Int): Int {
            return count[i shr 6] + popcountll(block[i shr 6] and ((1L shl (i and 63)) - 1))
        }

        // Rank1FromTo counts number of 1's in [i, j)
        fun rank1FromTo(i: Int, j: Int): Int {
            return rank1(j) - rank1(i)
        }

        // Rank0 counts number of 0's in [0, i)
        fun rank0(i: Int): Int {
            return i - rank1(i)
        }

        // Rank0FromTo counts number of 0's in [i, j)
        fun rank0FromTo(i: Int, j: Int): Int {
            return rank0(j) - rank0(i)
        }
    }

    // WaveletMatrix is a wavelet matrix data structure
    class WaveletMatrix {
        private var height: Int = 0
        private lateinit var B: Array<BitRank>
        private lateinit var pos: IntArray

        // Constructor creates a new wavelet matrix
        constructor(vec: IntArray, vararg sigma: Int) {
            var s = 0
            if (sigma.isNotEmpty()) {
                s = sigma[0]
            } else {
                // Find the maximum element and use that as sigma
                for (v in vec) {
                    if (v > s) {
                        s = v
                    }
                }
                s++
            }

            init(vec, s)
        }

        private fun init(vec: IntArray, sigma: Int) {
            // Calculate height based on sigma value
            height = if (sigma == 1) {
                1
            } else {
                64 - java.lang.Long.numberOfLeadingZeros((sigma - 1).toLong())
            }

            B = Array(height) { BitRank() }
            pos = IntArray(height)

            for (i in 0 until height) {
                B[i].resize(vec.size)

                for (j in vec.indices) {
                    B[i].set(j, get(vec[j], height - i - 1))
                }

                B[i].build()

                pos[i] = stablePartition(vec) { get(it, height - i - 1) == 0 }
            }
        }

        // stablePartition is equivalent to C++ stable_partition
        private fun stablePartition(arr: IntArray, predicate: (Int) -> Boolean): Int {
            val result = ArrayList<Int>(arr.size)
            val falseValues = ArrayList<Int>(arr.size)

            for (item in arr) {
                if (predicate(item)) {
                    result.add(item)
                } else {
                    falseValues.add(item)
                }
            }

            val partitionPoint = result.size
            result.addAll(falseValues)

            // Update the original array
            for (i in result.indices) {
                arr[i] = result[i]
            }

            return partitionPoint
        }

        // get returns bit at position i from val
        private fun get(value: Int, i: Int): Int {
            return (value shr i) and 1
        }

        // Rank counts occurrences of val in range [l, r)
        fun rank(value: Int, l: Int, r: Int): Int {
            return rankSingle(value, r) - rankSingle(value, l)
        }

        // RankSingle counts occurrences of val in range [0, i)
        fun rankSingle(value: Int, i: Int): Int {
            var p = 0
            var idx = i
            for (j in 0 until height) {
                if (get(value, height - j - 1) == 1) {
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
        fun quantile(k: Int, l: Int, r: Int): Int {
            var res = 0
            var left = l
            var right = r
            var kVal = k

            for (i in 0 until height) {
                val j = B[i].rank0FromTo(left, right)
                if (j > kVal) {
                    left = B[i].rank0(left)
                    right = B[i].rank0(right)
                } else {
                    left = pos[i] + B[i].rank1(left)
                    right = pos[i] + B[i].rank1(right)
                    kVal -= j
                    res = res or (1 shl (height - i - 1))
                }
            }
            return res
        }

        // RangeFreq counts elements in [l, r) that are in value range [a, b)
        fun rangeFreq(l: Int, r: Int, a: Int, b: Int): Int {
            return rangeFreqRecursive(l, r, a, b, 0, 1 shl height, 0)
        }

        private fun rangeFreqRecursive(i: Int, j: Int, a: Int, b: Int, l: Int, r: Int, x: Int): Int {
            if (i == j || r <= a || b <= l) {
                return 0
            }

            val mid = (l + r) shr 1
            return if (a <= l && r <= b) {
                j - i
            } else {
                val left = rangeFreqRecursive(
                    B[x].rank0(i),
                    B[x].rank0(j),
                    a, b, l, mid, x + 1
                )
                val right = rangeFreqRecursive(
                    pos[x] + B[x].rank1(i),
                    pos[x] + B[x].rank1(j),
                    a, b, mid, r, x + 1
                )
                left + right
            }
        }

        // RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
        fun rangeMin(l: Int, r: Int, a: Int, b: Int): Int {
            return rangeMinRecursive(l, r, a, b, 0, 1 shl height, 0, 0)
        }

        private fun rangeMinRecursive(i: Int, j: Int, a: Int, b: Int, l: Int, r: Int, x: Int, value: Int): Int {
            if (i == j || r <= a || b <= l) {
                return -1
            }
            if (r - l == 1) {
                return value
            }

            val mid = (l + r) shr 1
            val res = rangeMinRecursive(
                B[x].rank0(i),
                B[x].rank0(j),
                a, b, l, mid, x + 1, value
            )

            return if (res < 0) {
                rangeMinRecursive(
                    pos[x] + B[x].rank1(i),
                    pos[x] + B[x].rank1(j),
                    a, b, mid, r, x + 1,
                    value + (1 shl (height - x - 1))
                )
            } else {
                res
            }
        }
    }

    companion object {
        // binary search to find index in sorted array
        private fun find(arr: IntArray, x: Int): Int {
            var left = 0
            var right = arr.size
            while (left < right) {
                val mid = (left + right) / 2
                if (arr[mid] < x) {
                    left = mid + 1
                } else {
                    right = mid
                }
            }
            return left
        }

        @JvmStatic
        fun main(args: Array<String>) {
            val n = 5
            val a = intArrayOf(3374, 956, 2114, 3415, 3437)

            val input = a.copyOf(n)
            val backup = a.copyOf(n)

            // Sort and deduplicate the array
            val sortedA = a.copyOf(n).also { it.sort() }

            // Deduplicate
            val uniqueAList = ArrayList<Int>()
            for (i in sortedA.indices) {
                if (i == 0 || sortedA[i] != sortedA[i - 1]) {
                    uniqueAList.add(sortedA[i])
                }
            }

            // Convert List to array
            val uniqueA = IntArray(uniqueAList.size)
            for (i in uniqueAList.indices) {
                uniqueA[i] = uniqueAList[i]
            }

            // Map original values to their indices in the unique array
            for (i in 0 until n) {
                input[i] = find(uniqueA, backup[i])
            }

            val lrkVector = arrayOf(
                intArrayOf(2, 2, 1),
                intArrayOf(3, 4, 1),
                intArrayOf(4, 5, 1),
                intArrayOf(1, 2, 2),
                intArrayOf(4, 4, 1)
            )

            val wm = WaveletMatrix(input)

            for (lrk in lrkVector) {
                val l = lrk[0] - 1 // Convert to 0-indexed
                val r = lrk[1]
                val k = lrk[2]
                println(uniqueA[wm.quantile(k - 1, l, r)])
            }
        }
    }
}
