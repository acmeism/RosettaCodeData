fn binary_search_rec(a []f64, value f64, low int, high int) int { // recursive
    if high <= low {
        return -1
    }
    mid := (low + high) / 2
    if a[mid] > value {
        return binary_search_rec(a, value, low, mid-1)
    } else if a[mid] < value {
        return binary_search_rec(a, value, mid+1, high)
    }
    return mid
}
fn binary_search_it(a []f64, value f64) int { //iterative
    mut low := 0
    mut high := a.len - 1
    for low <= high {
        mid := (low + high) / 2
        if a[mid] > value {
            high = mid - 1
        } else if a[mid] < value {
            low = mid + 1
        } else {
            return mid
        }
    }
    return -1
}
fn main() {
    f_list := [1.2,1.5,2,5,5.13,5.4,5.89,9,10]
    println(binary_search_rec(f_list,9,0,f_list.len))
    println(binary_search_rec(f_list,15,0,f_list.len))

    println(binary_search_it(f_list,9))
    println(binary_search_it(f_list,15))
}
