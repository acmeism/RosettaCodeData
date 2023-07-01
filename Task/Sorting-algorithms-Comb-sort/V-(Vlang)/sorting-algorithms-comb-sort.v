fn main() {
    mut a := [170, 45, 75, -90, -802, 24, 2, 66]
    println("before: $a")
    comb_sort(mut a)
    println("after: $a")
}

fn comb_sort(mut a []int) {
    if a.len < 2 {
        return
    }
    for gap := a.len; ; {
        if gap > 1 {
            gap = gap * 4 / 5
        }
        mut swapped := false
        for i := 0; ; {
            if a[i] > a[i+gap] {
                a[i], a[i+gap] = a[i+gap], a[i]
                swapped = true
            }
            i++
            if i+gap >= a.len {
                break
            }
        }
        if gap == 1 && !swapped {
            break
        }
    }
}
