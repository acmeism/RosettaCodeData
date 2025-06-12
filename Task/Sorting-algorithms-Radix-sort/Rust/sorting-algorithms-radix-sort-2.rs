fn radix_sort(arr: &mut [u32]) {
    let mut buf = vec![0; arr.len()];

    // Optional: Reduce the amount of iterations by finding the max value bit
    let max_bit = u32::BITS - arr.iter().max().map(|t| t.leading_zeros()).unwrap_or(0);

    for bit in 0..max_bit {
        // Manual implementation of partition with only one buffer array
        let mut a = 0;
        let mut b = 0;

        for i in 0..arr.len() {
            if arr[i] >> bit & 1 == 0 {
                arr[a] = arr[i];
                a += 1;
            } else {
                buf[b] = arr[i];
                b += 1;
            }
        }

        arr[a..].copy_from_slice(&buf[..b]);
    }
}
