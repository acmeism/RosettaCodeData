// Compare lenth of two strings, in V
// Tectonics: v run compare-length-of-two-strings.v
module main

// starts here
pub fn main() {
    mut strs := ["abcd","123456789"]
    println("Given: $strs")
    strs.sort_by_len()
    for i := strs.len-1; i >= 0; i-- {
        println("${strs[i]}: with length ${strs[i].len}")
    }

    // more than 2 strings. note = vs :=, := for definition, = for assignment
    strs = ["abcd","123456789","abcdef","1234567"]
    println("\nGiven: $strs")
    strs.sort_by_len()
    for i := strs.len-1; i >= 0; i-- {
        println("${strs[i]}: with length ${strs[i].len}")
    }
}
