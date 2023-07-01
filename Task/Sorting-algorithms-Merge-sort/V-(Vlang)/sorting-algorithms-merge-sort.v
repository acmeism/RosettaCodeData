fn main() {
    mut a := [170, 45, 75, -90, -802, 24, 2, 66]
    println("before: $a")
    a = merge_sort(a)
    println("after: $a")
}

fn merge_sort(m []int) []int {
    if m.len <= 1{
        return m
    } else {
        mid := m.len / 2
        mut left := merge_sort(m[..mid])
        mut right := merge_sort(m[mid..])
        if m[mid-1] <= m[mid] {
            left << right
            return left
        }
        return merge(mut left, mut right)
    }
}

fn merge(mut left []int,mut right []int) []int {
    mut result := []int{}
    for left.len > 0 && right.len > 0 {
        if left[0] <= right[0]{
            result << left[0]
            left = left[1..]
        } else {
            result << right[0]
            right = right[1..]
        }
    }
    if left.len > 0  {
        result << left
    }
    if right.len > 0 {
        result << right
    }
    return result
}
