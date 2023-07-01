func jortSort<T:Comparable>(inout array: [T]) -> Bool {

    // sort the array
    let originalArray = array
    array.sort({$0 < $1})

    // compare to see if it was originally sorted
    for var i = 0; i < originalArray.count; ++i {
        if originalArray[i] != array[i] { return false }
    }

    return true
}
