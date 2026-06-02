def MAX = 5; // compile time constant

fn countdown(limit: const int) {  // read-only parameter
   // limit = 10; Cannot assign to const variable 'limit'
   for i in limit..=0 step -1 { println "{i}" }
}

fn main() {
    let x: const int = 6;  // read-only variable
    // x = 10;             // error: Cannot assign to const variable 'x'
    println "{x}";
    countdown(MAX);
}
