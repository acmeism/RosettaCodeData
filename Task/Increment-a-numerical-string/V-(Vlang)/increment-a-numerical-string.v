// Increment a numerical string in V
module main

// V int conversion will give 0 for nonnumeric strings
pub fn main() {
    mut numstr := "-5"
    print("numstr: ${numstr:-5} ")
    numstr = (numstr.int()+1).str()
    println("numstr: $numstr")

    // Run a few tests
    for testrun in ["0", "100", "00110", "abc", "41"] {
        print("numstr: $testrun  ")
        numstr = (testrun.int()+1).str()
        println("numstr: $numstr")
    }
}
