config const N = 30;
for p in sieve(2) {
        if p > N {
                writeln();
                break;
        }
        write(" ", p);
}
