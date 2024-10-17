import std.stdio, std.algorithm, std.range;

int[][] Josephus(in int n, int k, int s=1) {
    int[] ks, ps = n.iota.array;
    for (int i=--k; ps.length>s; i=(i+k)%ps.length) {
        ks ~= ps[i];
        ps = remove(ps, i);
    }
    writefln("Josephus(%d,%d,%d) -> %(%d %) / %(%d %)%s", n, k, s, ps, ks[0..min($,45)], ks.length<45 ? "" : " ..." );
    return [ps, ks];
}

void main() {
    Josephus(5, 2);
    Josephus(41, 3);
    Josephus(23482, 3343, 3);
}}
