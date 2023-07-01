// This function performs an insertion sort with an array.
// The input parameter is a generic array (any type that can perform comparison).
// As is typical of functional programming style the input array is not modified;
// a copy of the input array is made and modified and returned.
let insertionSort (A: _ array) =
    let B = Array.copy A
    for i = 1 to B.Length - 1 do
        let mutable value = B.[i]
        let mutable j = i - 1
        while (j >= 0 && B.[j] > value) do
            B.[j+1] <- B.[j]
            j <- j - 1
        B.[j+1] <- value
    B  // the array B is returned
