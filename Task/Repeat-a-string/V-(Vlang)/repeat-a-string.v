// Repeat a string, in V
// Tectonics: v run repeat-a-string.v
module main
import strings

// starts here
pub fn main() {
    // A strings module function to repeat strings
    println(strings.repeat_string("ha", 5))

    // Another strings module function to repeat a byte
    // This indexes the string to get the first byte of the rune array
    println(strings.repeat("*"[0], 5))
}
