import std.stdio, std.algorithm;

void iterate(bool doPrint=true)(double[] v, double[] diff) {
    static ref T E(T)(T[] x, in size_t row, in size_t col)
    pure nothrow {
        return x[row * (row + 1) / 2 + col];
    }

    double sum = 0.0;
    do {
        // enforce boundary conditions
        E(v, 0, 0) = 151;
        E(v, 2, 0) = 40;
        E(v, 4, 1) = 11;
        E(v, 4, 3) = 4;

        // calculate difference from equilibrium
        foreach (i; 1 .. 5) {
            foreach (j; 0 .. i + 1) {
                E(diff, i, j) = 0;
                if (j < i)
                    E(diff, i, j) += E(v, i - 1, j) -
                                     E(v, i, j + 1) -
                                     E(v, i, j);
                if (j)
                    E(diff, i, j) += E(v, i - 1, j - 1) -
                                     E(v, i, j - 1) -
                                     E(v, i, j);
            }
        }

        foreach (i; 1 .. 4)
            foreach (j; 0 .. i)
                E(diff, i, j) += E(v, i + 1, j) +
                                 E(v, i + 1, j + 1) -
                                 E(v, i, j);

        E(diff, 4, 2) += E(v, 4, 0) + E(v, 4, 4) - E(v, 4, 2);

        // do feedback, check if we are close enough
        // 4: scale down the feedback to avoid oscillations
        v[] += diff[] / 4;
        sum = reduce!q{a + b ^^ 2}(0.0, diff);

        static if (doPrint)
            writeln("dev: ", sum);

        // sum(dx^2) < 0.1 means each cell is no more than 0.5 away
        // from equilibrium. It takes about 50 iterations. After
        // 700 iterations sum is < 1e-25, but that's overkill.
    } while (sum >= 0.1);
}

void main() {
    static void show(in double[] x) {
        int idx;
        foreach (i; 0 .. 5)
            foreach (j; 0 .. i+1) {
                printf("%4d%c", cast(int)(0.5 + x[idx]),
                       j < i ? ' ' : '\n');
                idx++;
            }
    }

    double[15] v = 0.0;
    double[15] diff = 0.0;
    iterate(v, diff);
    show(v);
}
