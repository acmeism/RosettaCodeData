fn bubble_sort<T: Ord>(arr: &mut [T]) {
    let mut n = arr.len();
    let mut swapped = true;

    while swapped {
        swapped = false;

        for i in 1..n {
            if arr[i - 1] > arr[i] {
                arr.swap(i - 1, i);
                swapped = true;
            }
        }

        n -= 1;
    }
}

fn insertion_sort<T: Ord>(arr: &mut [T]) {
    for i in 1..arr.len() {
        let mut j = i;
        while j > 0 && arr[j] < arr[j - 1] {
            arr.swap(j, j - 1);
            j -= 1;
        }
    }
}

fn quick_sort<T: Ord + Copy>(arr: &mut [T]) {
    if arr.len() >= 2 {
        let pivot = partition(arr);
        quick_sort(&mut arr[..pivot]);
        quick_sort(&mut arr[pivot..]);
    }
}

/// In order to sort 100,000 integers without overflowing the stack, we use Hoare's partition scheme
/// which moves iterators from both ends of the slice towards the center until they cross.
/// This is especially effective for slicing sequences that are nearly/fully sorted.
fn partition<T: Ord + Copy>(arr: &mut [T]) -> usize {
    let pivot = arr[arr.len() / 2];

    let mut i = 0;
    let mut j = arr.len() - 1;

    loop {
        while arr[i] < pivot {
            i += 1;
        }
        while arr[j] > pivot {
            j -= 1;
        }

        if i >= j {
            return i;
        }

        arr.swap(i, j);
        i += 1;
        j -= 1;
    }
}

/// We are hard-coding the type for this example, since radix sorting on signed integers is a _bit_
/// more complicated than needed here.
fn radix_sort(arr: &mut [u32]) {
    let mut buf = vec![0; arr.len()];
    // Reduce the amount of iterations by finding the max value bit
    let max_bits = u32::BITS - arr.iter().max().unwrap().leading_zeros();

    for bit in 0..max_bits {
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

fn shell_sort<T: Ord + Copy>(arr: &mut [T]) {
    // Marcin Ciura's gap sequence
    for gap in [701, 301, 132, 57, 23, 10, 4, 1] {
        for i in gap..arr.len() {
            let temp = arr[i];
            let mut j = i;
            while j >= gap && arr[j - gap] > temp {
                arr[j] = arr[j - gap];
                j -= gap;
            }
            arr[j] = temp;
        }
    }
}

fn rust_stable_sort<T: Ord>(arr: &mut [T]) {
    arr.sort();
}

fn rust_unstable_sort<T: Ord>(arr: &mut [T]) {
    arr.sort_unstable();
}

const ALGOS: [(&'static str, fn(&mut [u32])); 7] = [
    ("Bubble", bubble_sort),
    ("Insert", insertion_sort),
    ("Quick", quick_sort),
    ("Radix", radix_sort),
    ("Shell", shell_sort),
    ("Drift", rust_stable_sort),
    ("IPN", rust_unstable_sort),
];
