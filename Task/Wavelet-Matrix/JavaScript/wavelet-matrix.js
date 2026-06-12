class BitRank {
  constructor() {
    this.block = [];
    this.count = [];
  }

  // Resize the bit vector to the given length
  resize(num) {
    this.block = new Array(Math.floor((num + 1) >> 6) + 1).fill(0n);
    this.count = new Array(this.block.length).fill(0);
  }

  // Set bit at position i
  set(i, val) {
    this.block[i >> 6] |= (BigInt(val) << BigInt(i & 63));
  }

  // Build the rank structure
  build() {
    for (let i = 1; i < this.block.length; i++) {
      this.count[i] = this.count[i - 1] + this.popcountll(this.block[i - 1]);
    }
  }

  // Count number of 1's in a 64-bit integer (popcount equivalent)
  popcountll(n) {
    let count = 0;
    while (n) {
      count += Number(n & 1n);
      n >>= 1n;
    }
    return count;
  }

  // Count number of 1's in [0, i)
  rank1(i) {
    return this.count[i >> 6] +
      this.popcountll(this.block[i >> 6] & ((1n << BigInt(i & 63)) - 1n));
  }

  // Count number of 1's in [i, j)
  rank1FromTo(i, j) {
    return this.rank1(j) - this.rank1(i);
  }

  // Count number of 0's in [0, i)
  rank0(i) {
    return i - this.rank1(i);
  }

  // Count number of 0's in [i, j)
  rank0FromTo(i, j) {
    return this.rank0(j) - this.rank0(i);
  }
}

class WaveletMatrix {
  constructor(vec, sigma) {
    if (sigma === undefined) {
      // Find the maximum element and use that as sigma
      sigma = Math.max(...vec) + 1;
    }
    this.init(vec, sigma);
  }

  init(vec, sigma) {
    // Calculate height based on sigma value
    this.height = (sigma === 1) ? 1 : (64 - Math.clz32(sigma - 1));
    this.B = new Array(this.height);
    this.pos = new Array(this.height);

    for (let i = 0; i < this.height; i++) {
      this.B[i] = new BitRank();
      this.B[i].resize(vec.length);

      for (let j = 0; j < vec.length; j++) {
        this.B[i].set(j, this.get(vec[j], this.height - i - 1));
      }

      this.B[i].build();

      // Stable partition - separate 0's and 1's while preserving order
      const partition = this.stablePartition(vec, c => !this.get(c, this.height - i - 1));
      this.pos[i] = partition;
    }
  }

  // Stable partition implementation (equivalent to C++ stable_partition)
  stablePartition(arr, predicate) {
    const result = [];
    const falseValues = [];

    for (const item of arr) {
      if (predicate(item)) {
        result.push(item);
      } else {
        falseValues.push(item);
      }
    }

    const partitionPoint = result.length;
    result.push(...falseValues);

    // Update the original array
    for (let i = 0; i < arr.length; i++) {
      arr[i] = result[i];
    }

    return partitionPoint;
  }

  // Get bit at position i from val
  get(val, i) {
    return (val >> i) & 1;
  }

  // Count occurrences of val in range [l, r)
  rank(val, l, r) {
    if (r === undefined) {
      // Single parameter version: [0, l)
      return this.rankSingle(val, l);
    }
    return this.rankSingle(val, r) - this.rankSingle(val, l);
  }

  // Count occurrences of val in range [0, i)
  rankSingle(val, i) {
    let p = 0;
    for (let j = 0; j < this.height; j++) {
      if (this.get(val, this.height - j - 1)) {
        p = this.pos[j] + this.B[j].rank1(p);
        i = this.pos[j] + this.B[j].rank1(i);
      } else {
        p = this.B[j].rank0(p);
        i = this.B[j].rank0(i);
      }
    }
    return i - p;
  }

  // kth smallest element in [l, r)
  quantile(k, l, r) {
    let res = 0;
    for (let i = 0; i < this.height; i++) {
      const j = this.B[i].rank0FromTo(l, r);
      if (j > k) {
        l = this.B[i].rank0(l);
        r = this.B[i].rank0(r);
      } else {
        l = this.pos[i] + this.B[i].rank1(l);
        r = this.pos[i] + this.B[i].rank1(r);
        k -= j;
        res |= (1 << (this.height - i - 1));
      }
    }
    return res;
  }

  // Count elements in [l, r) that are in value range [a, b)
  rangefreq(l, r, a, b) {
    return this.rangefreqRecursive(l, r, a, b, 0, 1 << this.height, 0);
  }

  rangefreqRecursive(i, j, a, b, l, r, x) {
    if (i === j || r <= a || b <= l) return 0;
    const mid = (l + r) >> 1;
    if (a <= l && r <= b) {
      return j - i;
    } else {
      const left = this.rangefreqRecursive(
        this.B[x].rank0(i),
        this.B[x].rank0(j),
        a, b, l, mid, x + 1
      );
      const right = this.rangefreqRecursive(
        this.pos[x] + this.B[x].rank1(i),
        this.pos[x] + this.B[x].rank1(j),
        a, b, mid, r, x + 1
      );
      return left + right;
    }
  }

  // Find minimum value in [l, r) within value range [a, b), -1 if not found
  rangemin(l, r, a, b) {
    return this.rangeminRecursive(l, r, a, b, 0, 1 << this.height, 0, 0);
  }

  rangeminRecursive(i, j, a, b, l, r, x, val) {
    if (i === j || r <= a || b <= l) return -1;
    if (r - l === 1) return val;

    const mid = (l + r) >> 1;
    const res = this.rangeminRecursive(
      this.B[x].rank0(i),
      this.B[x].rank0(j),
      a, b, l, mid, x + 1, val
    );

    if (res < 0) {
      return this.rangeminRecursive(
        this.pos[x] + this.B[x].rank1(i),
        this.pos[x] + this.B[x].rank1(j),
        a, b, mid, r, x + 1,
        val + (1 << (this.height - x - 1))
      );
    } else {
      return res;
    }
  }
}

// Main function
function main() {
  const n = 5;
  const q = 5;
  const a = [ 3374, 956, 2114, 3415, 3437 ]

  const input = [...a];
  const backup = [...a];

  // Sort and deduplicate the array
  const sortedA = [...a].sort((a, b) => a - b);
  const uniqueA = [...new Set(sortedA)];

  // Function to find index of an element in the unique array
  const find = (x) => {
    let left = 0;
    let right = uniqueA.length;
    while (left < right) {
      const mid = Math.floor((left + right) / 2);
      if (uniqueA[mid] < x) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }
    return left;
  };

  // Map original values to their indices in the unique array
  for (let i = 0; i < n; i++) {
    input[i] = find(backup[i]);
  }

  const lrk_vector = [[2, 2, 1], [3, 4, 1], [4, 5, 1], [1, 2, 2], [4, 4, 1]];

  const wm = new WaveletMatrix(input);

  for (const lrk of lrk_vector) {
    let [l, r, k] = lrk;
    l--;  // Convert to 0-indexed
    console.log(uniqueA[wm.quantile(k - 1, l, r)]);
  }
}

// Execute the main function
main();
