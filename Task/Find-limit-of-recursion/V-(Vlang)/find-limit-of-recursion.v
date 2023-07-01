// Find limit of recursion, in V (Vlang)
module main

// starts here, then call down until stacks become faulty
pub fn main() {
    recurse(0)
}

fn recurse(n int) {
    println(n)
    recurse(n+1)
}
