// sorting an array in place
let nums = [| 2; 4; 3; 1; 2 |]
Array.sortInPlace nums

// create a sorted copy of a list
let nums2 = [2; 4; 3; 1; 2]
let sorted = List.sort nums2
