// Check file exists in V
// Tectonics: v run check-that-file-exists.v
module main
import os

// starts here
pub fn main() {
    // file and directory checks
    _ := os.execute("touch input.txt")
    println("os.is_file('input.txt'): ${os.is_file('input.txt')}")

    // make doc directory in current dir if it doesn't exist
    _ := os.execute("mkdir -p doc")
    println("os.is_dir('doc'): ${os.is_dir('doc')}")

    // check in the root dir
    println("os.is_file('/input.txt'): ${os.is_file('/input.txt')}")
    println("os.is_dir('/doc'): ${os.is_dir('/doc')}")

    // check for file, with empty file
    _ := os.execute("truncate -s 0 empty.txt")
    println("os.is_file('empty.txt'): ${os.is_file('empty.txt')}")

    // check for file, with exotic name
    wfn := "`Abdu'l-Bahá.txt"
    efn := wfn.replace_each(["'", r"\'", "`", r"\`"])
    _ := os.execute('touch $efn')
    println('os.is_file("$wfn"): ${os.is_file(wfn)}')
}
