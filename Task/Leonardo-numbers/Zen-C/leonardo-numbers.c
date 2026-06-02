fn leonardo(first: (int, int), leo: int*, add: const int, limit: const int) {
    leo[0] = first.0;
    leo[1] = first.1;
    for i in 2..limit { leo[i] = leo[i-1] + leo[i-2] + add; }
}

fn main() {
    def LIMIT = 25;
    let leo: [int; LIMIT];
    println "The first {LIMIT} Leonardo numbers with L(0) = 1, L(1) = 1 and Add = 1 are:";
    leonardo((1, 1), (int*)leo, 1, LIMIT);
    for l in leo { print "{l} "}
    println "\n\nThe first {LIMIT} Leonardo numbers with L(0) = 0, L(1) = 1 and Add = 0 are:";
    for i in 0..LIMIT { leo[i] = 0; }
    leonardo((0, 1), (int*)leo, 0, LIMIT);
    for l in leo { print "{l} "}
    println "";
}
