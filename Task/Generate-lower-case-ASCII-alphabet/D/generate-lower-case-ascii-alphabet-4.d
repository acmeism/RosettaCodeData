void main() {
    char[] arr;

    foreach (immutable char c; 'a' .. 'z' + 1)
        arr ~= c;

    assert(arr == "abcdefghijklmnopqrstuvwxyz");
}
