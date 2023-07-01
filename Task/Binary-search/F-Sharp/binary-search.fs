let rec binarySearch (myArray:array<IComparable>, low:int, high:int, value:IComparable) =
    if (high < low) then
        null
    else
        let mid = (low + high) / 2

        if (myArray.[mid] > value) then
            binarySearch (myArray, low, mid-1, value)
        else if (myArray.[mid] < value) then
            binarySearch (myArray, mid+1, high, value)
        else
            myArray.[mid]
