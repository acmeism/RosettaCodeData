import std.array : array, uninitializedArray;
import std.range : iota;
import std.stdio : writeln;
import std.typecons : tuple;

alias vector = double[4];
alias matrix = vector[4];

auto johnsonTrotter(int n) {
    auto p = iota(n).array;
    auto q = iota(n).array;
    auto d = uninitializedArray!(int[])(n);
    d[] = -1;
    auto sign = 1;
    int[][] perms;
    int[] signs;

    void permute(int k) {
        if (k >= n) {
            perms ~= p.dup;
            signs ~= sign;
            sign *= -1;
            return;
        }
        permute(k + 1);
        foreach (i; 0..k) {
            auto z = p[q[k] + d[k]];
            p[q[k]] = z;
            p[q[k] + d[k]] = k;
            q[z] = q[k];
            q[k] += d[k];
            permute(k + 1);
        }
        d[k] *= -1;
    }

    permute(0);
    return tuple!("sigmas", "signs")(perms, signs);
}

auto determinant(matrix m) {
    auto jt = johnsonTrotter(m.length);
    auto sum = 0.0;
    foreach (i,sigma; jt.sigmas) {
        auto prod = 1.0;
        foreach (j,s; sigma) {
            prod *= m[j][s];
        }
        sum += jt.signs[i] * prod;
    }
    return sum;
}

auto cramer(matrix m, vector d) {
    auto divisor = determinant(m);
    auto numerators = uninitializedArray!(matrix[])(m.length);
    foreach (i; 0..m.length) {
        foreach (j; 0..m.length) {
            foreach (k; 0..m.length) {
                numerators[i][j][k] = m[j][k];
            }
        }
    }
    vector v;
    foreach (i; 0..m.length) {
        foreach (j; 0..m.length) {
            numerators[i][j][i] = d[j];
        }
    }
    foreach (i; 0..m.length) {
        v[i] = determinant(numerators[i]) / divisor;
    }
    return v;
}

void main() {
    matrix m = [
        [2.0, -1.0,  5.0,  1.0],
        [3.0,  2.0,  2.0, -6.0],
        [1.0,  3.0,  3.0, -1.0],
        [5.0, -2.0, -3.0,  3.0]
    ];
    vector d = [-3.0, -32.0, -47.0, 49.0];
    auto wxyz = cramer(m, d);
    writeln("w = ", wxyz[0], ", x = ", wxyz[1], ", y = ", wxyz[2], ", z = ", wxyz[3]);
}
