function heapSort(arr) {
    heapify(arr)
    end = arr.length - 1
    while (end > 0) {
        [arr[end], arr[0]] = [arr[0], arr[end]]
        end--
        siftDown(arr, 0, end)
    }
}

function heapify(arr) {
    start = Math.floor(arr.length/2) - 1

    while (start >= 0) {
        siftDown(arr, start, arr.length - 1)
        start--
    }
}

function siftDown(arr, startPos, endPos) {
    let rootPos = startPos

    while (rootPos * 2 + 1 <= endPos) {
        childPos = rootPos * 2 + 1
        if (childPos + 1 <= endPos && arr[childPos] < arr[childPos + 1]) {
            childPos++
        }
        if (arr[rootPos] < arr[childPos]) {
            [arr[rootPos], arr[childPos]] = [arr[childPos], arr[rootPos]]
            rootPos = childPos
        } else {
            return
        }
    }
}
test('rosettacode', () => {
    arr = [12, 11, 15, 10, 9, 1, 2, 3, 13, 14, 4, 5, 6, 7, 8,]
    heapSort(arr)
    expect(arr).toStrictEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
})
