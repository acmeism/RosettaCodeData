def insertionSort(array) {
    for i in 1..!(array.size()) {
        def value := array[i]
        var j := i-1
        while (j >= 0 && array[j] > value) {
            array[j + 1] := array[j]
            j -= 1
        }
        array[j+1] := value
   }
}
