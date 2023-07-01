import std.bitmanip : BitArray;
import std.stdio;

enum N = 2_200;
enum N2 = 2*N*N;

void main() {
    BitArray found;
    found.length = N+1;

    BitArray aabb;
    aabb.length = N2+1;

    uint s=3;

    for (uint a=1; a<=N; ++a) {
        uint aa = a*a;
        for (uint b=1; b<N; ++b) {
            aabb[aa + b*b] = true;
        }
    }

    for (uint c=1; c<=N; ++c) {
        uint s1 = s;
        s += 2;
        uint s2 = s;
        for (uint d=c+1; d<=N; ++d) {
            if (aabb[s1]) {
                found[d] = true;
            }
            s1 += s2;
            s2 += 2;
        }
    }

    writeln("The values of d <= ", N, " which can't be represented:");
    for (uint d=1; d<=N; ++d) {
        if (!found[d]) {
            write(d, ' ');
        }
    }
    writeln;
}
