fn main() {
    let n: const int = 12;
    for j in 1..=n { printf("%3d%c", j, j != n ? ' ' : '\n'); }
    for j in 0..=n { printf(j != n ? "----" : "+\n"); }

    for i in 1..=n {
        for j in 1..=n {
		    printf(j < i ? "  - " : "%3d ", i * j);
        }
        printf("| %d\n", i);
    }
}
