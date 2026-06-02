fn catcmp(a: const void*, b: const void*) -> int {
    let ab = "{*(int*)a}{*(int*)b}";
    let ba = "{*(int*)b}{*(int*)a}";
    return strcmp(ba, ab);
}

fn maxcat(a: int*, len: int) {
    print "[";
    for i in 0..len { print "{a[i]}, "; }
    print "\b\b] -> ";
    qsort(a, len, sizeof(int), catcmp);
    for i in 0..len { print "{a[i]}"; }
    println "";
}

fn main() {
    let x = [1, 34, 3, 98, 9, 76, 45, 4];
    let y = [54, 546, 548, 60];
    maxcat((int*)x, 8);
    maxcat((int*)y, 4);
}
