int main () {
    char a[] = "thisisatest";
    char b[] = "testing123testing";
    int n = sizeof a - 1;
    int m = sizeof b - 1;
    char *s = NULL;
    int t = lcs(a, n, b, m, &s);
    printf("%.*s\n", t, s); // tsitest
    return 0;
}
