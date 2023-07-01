func selectionSort(inout arr:[Int]) {
    var min:Int

    for n in 0..<arr.count {
        min = n

        for x in n+1..<arr.count {
            if (arr[x] < arr[min]) {
                min = x
            }
        }

        if min != n {
            let temp = arr[min]
            arr[min] = arr[n]
            arr[n] = temp
        }
    }
}
