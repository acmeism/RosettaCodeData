import std.array;
import std.random;
import std.stdio;

alias Matrix = int[][];

void latinSquare(int n) {
    if (n <= 0) {
        writeln("[]");
        return;
    }

    Matrix latin = uninitializedArray!Matrix(n, n);
    foreach (row; latin) {
        for (int i = 0; i < n; i++) {
            row[i] = i;
        }
    }
    // first row
    latin[0].randomShuffle;

    // middle row(s)
    for (int i = 1; i < n - 1; i++) {
        bool shuffled = false;

        shuffling:
        while (!shuffled) {
            latin[i].randomShuffle;
            for (int k = 0; k < i; k++) {
                for (int j = 0; j < n; j++) {
                    if (latin[k][j] == latin[i][j]) {
                        continue shuffling;
                    }
                }
            }
            shuffled = true;
        }
    }

    // last row
    for (int j = 0; j < n; j++) {
        bool[] used = uninitializedArray!(bool[])(n);
        used[] = false;

        for (int i = 0; i < n - 1; i++) {
            used[latin[i][j]] = true;
        }
        for (int k = 0; k < n; k++) {
            if (!used[k]) {
                latin[n - 1][j] = k;
                break;
            }
        }
    }

    printSquare(latin);
}

void printSquare(Matrix latin) {
    foreach (row; latin) {
        writeln(row);
    }
}

void main() {
    latinSquare(5);
    writeln;

    latinSquare(5);
    writeln;

    latinSquare(10);
}
