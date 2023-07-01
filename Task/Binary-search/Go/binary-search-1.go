func binarySearch(a []float64, value float64, low int, high int) int {
    if high < low {
        return -1
    }
    mid := (low + high) / 2
    if a[mid] > value {
        return binarySearch(a, value, low, mid-1)
    } else if a[mid] < value {
        return binarySearch(a, value, mid+1, high)
    }
    return mid
}
