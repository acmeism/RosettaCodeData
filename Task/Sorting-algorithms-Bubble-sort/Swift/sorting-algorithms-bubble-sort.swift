func bubbleSort<T:Comparable>(list:inout[T]) {
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

var list1 = [3, 1, 7, 5, 2, 5, 3, 8, 4]
print(list1)
bubbleSort(list: &list1)
print(list1)
