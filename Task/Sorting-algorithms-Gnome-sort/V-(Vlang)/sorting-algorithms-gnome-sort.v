fn main() {
    mut a := [170, 45, 75, -90, -802, 24, 2, 66]
    println("before: $a")
    gnome_sort(mut a)
    println("after: $a")
}

fn gnome_sort(mut a []int) {
    for i, j := 1, 2; i < a.len; {
        if a[i-1] > a[i] {
            a[i-1], a[i] = a[i], a[i-1]
            i--
            if i > 0 {
                continue
            }
        }
        i = j
        j++
    }
}
