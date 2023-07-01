public static ulong Fib(uint n) {
    var M = new Matrix(1,0,0,1);
    var N = new Matrix(1,1,1,0);
    for (uint i = 1; i < n; i++) M *= N;
    return (ulong)M[0][0];
}
