func bubbleSort<T:Comparable>(inout list:[T]) {
    var done = false
    while !done {
        done = true
        for i in 1..<list.count {
            if list[i - 1] > list[i] {
                (list[i], list[i - 1]) = (list[i - 1], list[i])
                done = false
            }
        }
    }
}
