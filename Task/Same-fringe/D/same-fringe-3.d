import std.stdio, std.concurrency, std.range, std.algorithm;

struct Node(T) {
    T data;
    Node* L, R;
}

Generator!T fringe(T)(Node!T* t1) {
    return new typeof(return)({
        if (t1 != null) {
            if (t1.L == null && t1.R == null) // Is a leaf.
                yield(t1.data);
            else
                foreach (data; t1.L.fringe.chain(t1.R.fringe))
                    yield(data);
        }
    });
}

bool sameFringe(T)(Node!T* t1, Node!T* t2) {
    return t1.fringe.equal(t2.fringe);
}

void main() {
    alias N = Node!int;

    auto t1 = new N(10, new N(20, new N(30, new N(40), new N(50))));
    auto t2 = new N(1, new N(2, new N(3, new N(40), new N(50))));
    sameFringe(t1, t2).writeln;

    auto t3 = new N(1, new N(2, new N(3, new N(40), new N(51))));
    sameFringe(t1, t3).writeln;

    auto t4 = new N(1, new N(2, new N(3, new N(40))));
    sameFringe(t1, t4).writeln;

    N* t5;
    sameFringe(t1, t5).writeln;
    sameFringe(t5, t5).writeln;

    auto t6 = new N(2);
    auto t7 = new N(1, new N(2));
    sameFringe(t6, t7).writeln;
}
