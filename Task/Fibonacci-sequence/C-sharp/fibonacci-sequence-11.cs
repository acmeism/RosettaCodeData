private static Matrix M;
private static readonly Matrix N = new Matrix(1,1,1,0);

public static ulong Fib(uint n) {
    M = new Matrix(1,0,0,1);
    MatrixPow(n-1);
    return (ulong)M[0][0];
}

private static void MatrixPow(double n){
    if (n > 1) {
        MatrixPow(n/2);
        M *= M;
    }
    if (n % 2 == 0) M *= N;
}
