import std.stdio;

void main() {
    int n=8;
    foreach(row; magicSquareDoublyEven(n)) {
        foreach(col; row) {
            writef("%2s ", col);
        }
        writeln;
    }
    writeln("\nMagic constant: ", (n*n+1)*n/2);
}

int[][] magicSquareDoublyEven(int n) {
    import std.exception;
    enforce(n>=4 && n%4 == 0, "Base must be a positive multiple of 4");

    int bits = 0b1001_0110_0110_1001;
    int size = n * n;
    int mult = n / 4;  // how many multiples of 4

    int[][] result;
    result.length = n;
    foreach(i; 0..n) {
        result[i].length = n;
    }

    for (int r=0, i=0; r<n; r++) {
        for (int c=0; c<n; c++, i++) {
            int bitPos = c / mult + (r / mult) * 4;
            result[r][c] = (bits & (1 << bitPos)) != 0 ? i + 1 : size - i;
        }
    }

    return result;
}
