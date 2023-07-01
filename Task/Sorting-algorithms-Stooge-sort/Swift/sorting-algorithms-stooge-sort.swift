func stoogeSort(inout arr:[Int], _ i:Int = 0, var _ j:Int = -1) {
    if j == -1 {
        j = arr.count - 1
    }

    if arr[i] > arr[j] {
        swap(&arr[i], &arr[j])
    }

    if j - i > 1 {
        let t = (j - i + 1) / 3
        stoogeSort(&arr, i, j - t)
        stoogeSort(&arr, i + t, j)
        stoogeSort(&arr, i, j - t)
    }
}

var a = [-4, 2, 5, 2, 3, -2, 1, 100, 20]

stoogeSort(&a)

println(a)
