fn radix_sort(arr: &mut [i32]) {
    let mut buf = vec![0; arr.len()];

    // Optional: Reduce the number of iterations by finding the max value bit
    let max_bit = arr.iter().fold(0, |acc, x| {
        let bits = if x.is_negative() {
            i32::BITS - x.leading_ones() // Negative msb is always 1 so leading_ones() >= 1
        } else {
            i32::BITS - x.leading_zeros() // Positive/zero msb is always 0 so leading_zeros() >= 1
        };

        core::cmp::max(acc, bits)
    });
    let sign_bit = i32::BITS - 1;

    // Manual implementation of partition with only one buffer array
    let mut partition = |bit: u32| {
        let mut a = 0;
        let mut b = 0;

        for i in 0..arr.len() {
            // Flip the sign bit before comparing so negatives are always ordered before positives
            if (arr[i] ^ i32::MIN) >> bit & 1 == 0 {
                arr[a] = arr[i];
                a += 1;
            } else {
                buf[b] = arr[i];
                b += 1;
            }
        }

        arr[a..].copy_from_slice(&buf[..b]);
    };

    // This will not duplicate work because max_bits <= sign_bit therefore bit < sign_bit
    for bit in 0..max_bit {
        partition(bit);
    }
    partition(sign_bit);
}
