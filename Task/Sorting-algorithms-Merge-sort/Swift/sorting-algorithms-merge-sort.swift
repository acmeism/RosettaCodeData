func mergeSort<T:Comparable>(inout list:[T]) {
    if list.count <= 1 {
        return
    }

    func merge(var left:[T], var right:[T]) -> [T] {
        var result = [T]()

        while left.count != 0 && right.count != 0 {
            if left[0] <= right[0] {
                result.append(left.removeAtIndex(0))
            } else {
                result.append(right.removeAtIndex(0))
            }
        }

        while left.count != 0 {
            result.append(left.removeAtIndex(0))
        }

        while right.count != 0 {
            result.append(right.removeAtIndex(0))
        }

        return result
    }

    var left = [T]()
    var right = [T]()

    let mid = list.count / 2

    for i in 0..<mid {
        left.append(list[i])
    }

    for i in mid..<list.count {
        right.append(list[i])
    }

    mergeSort(&left)
    mergeSort(&right)

    list = merge(left, right)
}
