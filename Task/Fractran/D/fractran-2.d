import std.stdio, std.algorithm, std.conv, std.array, std.range;

struct Fractran {
    int front;
    bool empty = false;
    const int[][] fracts;

    this(in string prog, in int val) {
        this.front = val;
        fracts = prog.split.map!(p => p.split("/").to!(int[])).array;
    }

    void popFront() {
        const found = fracts.find!(p => front % p[1] == 0);
        if (found.empty)
            empty = true;
        else
            front = found.front[0] * front / found.front[1];
    }
}

void main() {
    Fractran("17/91 78/85 19/51 23/38 29/33 77/29 95/23
              77/19 1/17 11/13 13/11 15/14 15/2 55/1", 2)
    .take(15).writeln;
}
