// V, array concatenation
// Tectonics: v run array-concatenation.v
module main

// starts here
pub fn main() {
    mut arr1 := [1,2,3,4]
    arr2 := [5,6,7,8]

    arr1 << arr2
    println(arr1)
}
