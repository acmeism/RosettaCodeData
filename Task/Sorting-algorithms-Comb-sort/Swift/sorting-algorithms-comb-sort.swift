func combSort(inout list:[Int]) {
    var swapped = true
    var gap = list.count

    while gap > 1 || swapped {
        gap = gap * 10 / 13

        if gap == 9 || gap == 10 {
            gap = 11
        } else if gap < 1 {
            gap = 1
        }

        swapped = false

        for var i = 0, j = gap; j < list.count; i++, j++ {
            if list[i] > list[j] {
                (list[i], list[j]) = (list[j], list[i])
                swapped = true
            }
        }
    }
}
