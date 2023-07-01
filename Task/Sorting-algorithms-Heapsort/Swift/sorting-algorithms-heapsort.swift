func heapsort<T:Comparable>(inout list:[T]) {
    var count = list.count

    func shiftDown(inout list:[T], start:Int, end:Int) {
        var root = start

        while root * 2 + 1 <= end {
            var child = root * 2 + 1
            var swap = root

            if list[swap] < list[child] {
                swap = child
            }

            if child + 1 <= end && list[swap] < list[child + 1] {
                swap = child + 1
            }

            if swap == root {
                return
            } else {
                (list[root], list[swap]) = (list[swap], list[root])
                root = swap
            }
        }
    }

    func heapify(inout list:[T], count:Int) {
        var start = (count - 2) / 2

        while start >= 0 {
            shiftDown(&list, start, count - 1)

            start--
        }
    }

    heapify(&list, count)

    var end = count - 1

    while end > 0 {
        (list[end], list[0]) = (list[0], list[end])

        end--

        shiftDown(&list, 0, end)
    }
}
