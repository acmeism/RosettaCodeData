def median(list) {
    def sorted := list.sort()
    def count := sorted.size()
    def mid1 := count // 2
    def mid2 := (count - 1) // 2
    if (mid1 == mid2) {          # avoid inexact division
        return sorted[mid1]
    } else {
        return (sorted[mid1] + sorted[mid2]) / 2
    }
}
