struct Node(T) {
    T data;
    Node* L, R;
}

bool sameFringe(T)(Node!T* t1, Node!T* t2) {
    T[] scan(Node!T* t) {
        if (!t) return [];
        return (!t.L && !t.R) ? [t.data] : scan(t.L) ~ scan(t.R);
    }
    return scan(t1) == scan(t2);
}

void main() {
    import std.stdio;
    alias N = Node!int;
    auto t1 = new N(10, new N(20, new N(30, new N(40), new N(50))));
    auto t2 = new N(1, new N(2, new N(3, new N(40), new N(50))));
    writeln(sameFringe(t1, t2));
    auto t3 = new N(1, new N(2, new N(3, new N(40), new N(51))));
    writeln(sameFringe(t1, t3));
}
