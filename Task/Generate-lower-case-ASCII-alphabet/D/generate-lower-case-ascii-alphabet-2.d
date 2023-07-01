void main() {
    char['z' - 'a' + 1] arr;

    foreach (immutable i, ref c; arr)
        c = 'a' + i;
}
