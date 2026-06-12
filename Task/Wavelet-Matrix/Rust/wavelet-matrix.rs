#[derive(Clone)]
struct BitRank {
    block: Vec<u64>,
    count: Vec<i32>,
}

impl BitRank {
    // Resize resizes the bit vector to the given length
    fn resize(&mut self, num: usize) {
        // Fix the potential overflow in the calculation
        self.block = vec![0; ((num + 63) / 64) + 1]; // Safer way to calculate number of u64s needed
        self.count = vec![0; self.block.len()];
    }

    // Set sets bit at position i
    fn set(&mut self, i: usize, val: i32) {
        if val == 1 {
            self.block[i >> 6] |= 1u64 << (i & 63);
        }
    }

    // Build builds the rank structure
    fn build(&mut self) {
        for i in 1..self.block.len() {
            self.count[i] = self.count[i - 1] + self.popcountll(self.block[i - 1]);
        }
    }

    // popcountll counts number of 1's in a 64-bit integer
    fn popcountll(&self, n: u64) -> i32 {
        n.count_ones() as i32
    }

    // Rank1 counts number of 1's in [0, i)
    fn rank1(&self, i: usize) -> i32 {
        if i == 0 {
            return 0;
        }
        let block_idx = i >> 6;
        let bit_pos = i & 63;

        if block_idx >= self.block.len() {
            return self.count[self.count.len() - 1];
        }

        let mask = if bit_pos == 0 { 0 } else { (1u64 << bit_pos) - 1 };
        self.count[block_idx] + self.popcountll(self.block[block_idx] & mask)
    }

    // Rank1FromTo counts number of 1's in [i, j)
    fn rank1_from_to(&self, i: usize, j: usize) -> i32 {
        self.rank1(j) - self.rank1(i)
    }

    // Rank0 counts number of 0's in [0, i)
    fn rank0(&self, i: usize) -> i32 {
        i as i32 - self.rank1(i)
    }

    // Rank0FromTo counts number of 0's in [i, j)
    fn rank0_from_to(&self, i: usize, j: usize) -> i32 {
        self.rank0(j) - self.rank0(i)
    }
}

// Helper function to get bit at position i from val
fn get_bit(val: i32, i: i32) -> i32 {
    if i < 0 || i >= 32 {
        return 0; // Safe default for out of range bit positions
    }
    (val >> i) & 1
}

// WaveletMatrix is a wavelet matrix data structure
struct WaveletMatrix {
    height: i32,
    b: Vec<BitRank>,
    pos: Vec<i32>,
}

impl WaveletMatrix {
    // Create a new wavelet matrix
    fn new(vec: &[i32], sigma: Option<i32>) -> Self {
        let mut wm = WaveletMatrix {
            height: 0,
            b: Vec::new(),
            pos: Vec::new(),
        };

        let s = match sigma {
            Some(s) => s,
            None => {
                // Find the maximum element and use that as sigma
                let mut max_val = 0;
                for &v in vec {
                    if v > max_val {
                        max_val = v;
                    }
                }
                max_val + 1
            }
        };

        wm.init(vec, s);
        wm
    }

    fn init(&mut self, vec: &[i32], sigma: i32) {
        // Calculate height based on sigma value
        if sigma <= 1 {
            self.height = 1;
        } else {
            // Safely calculate the height to avoid overflow
            self.height = 32 - (sigma - 1).leading_zeros() as i32;
        }

        self.b = Vec::with_capacity(self.height as usize);
        for _ in 0..self.height {
            self.b.push(BitRank { block: Vec::new(), count: Vec::new() });
        }

        self.pos = vec![0; self.height as usize];

        let mut temp_vec = vec.to_vec();

        for i in 0..self.height as usize {
            self.b[i].resize(vec.len());

            for j in 0..vec.len() {
                // Using the standalone get_bit function to avoid borrowing self twice
                let bit_val = get_bit(temp_vec[j], self.height - i as i32 - 1);
                self.b[i].set(j, bit_val);
            }

            self.b[i].build();

            // Stable partition - separate 0's and 1's while preserving order
            let height_i = self.height - i as i32 - 1;  // Calculate once to avoid borrow issues
            self.pos[i] = self.stable_partition(&mut temp_vec, move |c| {
                get_bit(c, height_i) == 0
            }) as i32;
        }
    }

    // stable_partition is equivalent to C++ stable_partition
    fn stable_partition<F>(&self, arr: &mut Vec<i32>, predicate: F) -> usize
    where F: Fn(i32) -> bool {
        let mut result = Vec::with_capacity(arr.len());
        let mut false_values = Vec::with_capacity(arr.len());

        for &item in arr.iter() {
            if predicate(item) {
                result.push(item);
            } else {
                false_values.push(item);
            }
        }

        let partition_point = result.len();
        result.extend(false_values);

        // Update the original array
        arr.copy_from_slice(&result);

        partition_point
    }

    // Rank counts occurrences of val in range [l, r)
    fn rank(&self, val: i32, l: usize, r: usize) -> i32 {
        self.rank_single(val, r) - self.rank_single(val, l)
    }

    // RankSingle counts occurrences of val in range [0, i)
    fn rank_single(&self, val: i32, i: usize) -> i32 {
        let mut p = 0;
        let mut i = i as i32;
        for j in 0..self.height as usize {
            if get_bit(val, self.height - j as i32 - 1) == 1 {
                p = self.pos[j] + self.b[j].rank1(p as usize);
                i = self.pos[j] + self.b[j].rank1(i as usize);
            } else {
                p = self.b[j].rank0(p as usize);
                i = self.b[j].rank0(i as usize);
            }
        }
        i - p
    }

    // Quantile returns kth smallest element in [l, r)
    fn quantile(&self, k: i32, l: usize, r: usize) -> i32 {
        let mut res = 0;
        let mut k = k;
        let mut l = l;
        let mut r = r;

        for i in 0..self.height as usize {
            let j = self.b[i].rank0_from_to(l, r);
            if j > k {
                l = self.b[i].rank0(l) as usize;
                r = self.b[i].rank0(r) as usize;
            } else {
                l = (self.pos[i] + self.b[i].rank1(l)) as usize;
                r = (self.pos[i] + self.b[i].rank1(r)) as usize;
                k -= j;
                res |= 1 << (self.height - i as i32 - 1);
            }
        }
        res
    }

    // RangeFreq counts elements in [l, r) that are in value range [a, b)
    fn range_freq(&self, l: usize, r: usize, a: i32, b: i32) -> i32 {
        // Use a safer calculation for the maximum value
        let max_val = 1i32.checked_shl(self.height as u32).unwrap_or(0);
        self.range_freq_recursive(l, r, a, b, 0, max_val, 0)
    }

    fn range_freq_recursive(&self, i: usize, j: usize, a: i32, b: i32, l: i32, r: i32, x: usize) -> i32 {
        if i == j || r <= a || b <= l {
            return 0;
        }

        let mid = (l + r) >> 1;
        if a <= l && r <= b {
            return (j - i) as i32;
        } else {
            let left = self.range_freq_recursive(
                self.b[x].rank0(i) as usize,
                self.b[x].rank0(j) as usize,
                a, b, l, mid, x + 1,
            );
            let right = self.range_freq_recursive(
                (self.pos[x] + self.b[x].rank1(i)) as usize,
                (self.pos[x] + self.b[x].rank1(j)) as usize,
                a, b, mid, r, x + 1,
            );
            return left + right;
        }
    }

    // RangeMin finds minimum value in [l, r) within value range [a, b), -1 if not found
    fn range_min(&self, l: usize, r: usize, a: i32, b: i32) -> i32 {
        // Use a safer calculation for the maximum value
        let max_val = 1i32.checked_shl(self.height as u32).unwrap_or(0);
        self.range_min_recursive(l, r, a, b, 0, max_val, 0, 0)
    }

    fn range_min_recursive(&self, i: usize, j: usize, a: i32, b: i32, l: i32, r: i32, x: usize, val: i32) -> i32 {
        if i == j || r <= a || b <= l {
            return -1;
        }
        if r - l == 1 {
            return val;
        }

        let mid = (l + r) >> 1;
        let res = self.range_min_recursive(
            self.b[x].rank0(i) as usize,
            self.b[x].rank0(j) as usize,
            a, b, l, mid, x + 1, val,
        );

        if res < 0 {
            return self.range_min_recursive(
                (self.pos[x] + self.b[x].rank1(i)) as usize,
                (self.pos[x] + self.b[x].rank1(j)) as usize,
                a, b, mid, r, x + 1,
                val + (1 << (self.height - x as i32 - 1)),
            );
        } else {
            return res;
        }
    }
}

// binary search to find index in sorted array
fn find(arr: &[i32], x: i32) -> usize {
    let mut left = 0;
    let mut right = arr.len();
    while left < right {
        let mid = (left + right) / 2;
        if arr[mid] < x {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    left
}

fn main() {
    let n = 5;
    let a = vec![3374, 956, 2114, 3415, 3437];

    let mut input = a.clone();
    let backup = a.clone();

    // Sort and deduplicate the array
    let mut sorted_a = a.clone();
    sorted_a.sort();

    // Deduplicate
    let mut unique_a = Vec::new();
    for i in 0..sorted_a.len() {
        if i == 0 || sorted_a[i] != sorted_a[i-1] {
            unique_a.push(sorted_a[i]);
        }
    }

    // Map original values to their indices in the unique array
    for i in 0..n {
        input[i] = find(&unique_a, backup[i]) as i32;
    }

    let lrk_vector = vec![
        vec![2, 2, 1],
        vec![3, 4, 1],
        vec![4, 5, 1],
        vec![1, 2, 2],
        vec![4, 4, 1],
    ];

    let wm = WaveletMatrix::new(&input, None);

    for lrk in lrk_vector {
        let l = lrk[0] - 1; // Convert to 0-indexed
        let r = lrk[1];
        let k = lrk[2];
        println!("{}", unique_a[wm.quantile(k - 1, l as usize, r as usize) as usize]);
    }
}
