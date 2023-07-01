import std.math;
import std.stdio;

immutable MU_MAX = 1_000_000;

int mobiusFunction(int n) {
    static initialized = false;
    static int[MU_MAX + 1] MU;

    if (initialized) {
        return MU[n];
    }

    // populate array
    MU[] = 1;
    int root = cast(int) sqrt(cast(real) MU_MAX);

    for (int i = 2; i <= root; i++) {
        if (MU[i] == 1) {
            // for each factor found, swap + and -
            for (int j = i; j <= MU_MAX; j += i) {
                MU[j] *= -i;
            }
            // square factor = 0
            for (int j = i * i; j <= MU_MAX; j += i * i) {
                MU[j] = 0;
            }
        }
    }

    for (int i = 2; i <= MU_MAX; i++) {
        if (MU[i] == i) {
            MU[i] = 1;
        } else if (MU[i] == -i) {
            MU[i] = -1;
        } else if (MU[i] < 0) {
            MU[i] = 1;
        } else if (MU[i] > 0) {
            MU[i] = -1;
        }
    }

    initialized = true;
    return MU[n];
}

void main() {
    writeln("First 199 terms of the möbius function are as follows:");
    write("    ");
    for (int n = 1; n < 200; n++) {
        writef("%2d  ", mobiusFunction(n));
        if ((n + 1) % 20 == 0) {
            writeln;
        }
    }
}
