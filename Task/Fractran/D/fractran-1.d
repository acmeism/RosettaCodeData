import std.stdio, std.algorithm, std.conv, std.array;

void fractran(in string prog, int val, in uint limit) {
    const fracts = prog.split.map!(p => p.split("/").to!(int[])).array;

    foreach (immutable n; 0 .. limit) {
        writeln(n, ": ", val);
        const found = fracts.find!(p => val % p[1] == 0);
        if (found.empty)
            break;
        val = found.front[0] * val / found.front[1];
    }
}

void main() {
    fractran("17/91 78/85 19/51 23/38 29/33 77/29 95/23
              77/19 1/17 11/13 13/11 15/14 15/2 55/1", 2, 15);
}
