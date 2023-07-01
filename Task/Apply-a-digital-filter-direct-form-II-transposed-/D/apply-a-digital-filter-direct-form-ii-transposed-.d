import std.stdio;

alias T = real;
alias AT = T[];

AT filter(const AT a, const AT b, const AT signal) {
    AT result = new T[signal.length];

    foreach (int i; 0..signal.length) {
        T tmp = 0.0;
        foreach (int j; 0..b.length) {
            if (i-j<0) continue;
            tmp += b[j] * signal[i-j];
        }
        foreach (int j; 1..a.length) {
            if (i-j<0) continue;
            tmp -= a[j] * result[i-j];
        }
        tmp /= a[0];
        result[i] = tmp;
    }

    return result;
}

void main() {
    AT a = [1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17];
    AT b = [0.16666667, 0.5, 0.5, 0.16666667];

    AT signal = [
        -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412,
        -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044,
        0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,
        0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,
        0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589
    ];

    AT result = filter(a,b,signal);
    foreach (i; 0..result.length) {
        writef("% .8f", result[i]);
        if ((i+1)%5 != 0) {
            write(", ");
        } else {
            writeln;
        }
    }
}
