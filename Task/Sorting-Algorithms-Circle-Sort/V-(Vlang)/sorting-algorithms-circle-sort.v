fn circle_sort(mut a []int, l int, h int, s int) int {
    mut hi := h
    mut lo := l
    mut swaps := s
    if lo == hi {
        return swaps
    }
    high, low := hi, lo
    mid := (hi - lo) / 2
    for lo < hi {
        if a[lo] > a[hi] {
            a[lo], a[hi] = a[hi], a[lo]
            swaps++
        }
        lo++
        hi--
    }
    if lo == hi {
        if a[lo] > a[hi+1] {
            a[lo], a[hi+1] = a[hi+1], a[lo]
            swaps++
        }
    }
    swaps = circle_sort(mut a, low, low+mid, swaps)
    swaps = circle_sort(mut a, low+mid+1, high, swaps)
    return swaps
}

fn main() {
    aa := [
        [6, 7, 8, 9, 2, 5, 3, 4, 1],
        [2, 14, 4, 6, 8, 1, 3, 5, 7, 11, 0, 13, 12, -1],
    ]
    for a1 in aa {
        mut a:=a1.clone()
        println("Original: $a")
        for circle_sort(mut a, 0, a.len-1, 0) != 0 {
            // empty block
        }
        println("Sorted  : $a\n")
    }
}
