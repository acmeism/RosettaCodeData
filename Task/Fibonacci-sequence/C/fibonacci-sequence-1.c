long long fibb(long long a, long long b, int n) {
    return (--n>0)?(fibb(b, a+b, n)):(a);
}
