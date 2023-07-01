func insertionSort<T:Comparable>(inout list:[T]) {
    for i in 1..<list.count {
        var j = i

        while j > 0 && list[j - 1] > list[j] {
           swap(&list[j], &list[j - 1])
            j--
        }
    }
}
