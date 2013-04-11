const struct Node(T) {
    T v;
    Node* l, r;
}

T[] preOrder(T)(in Node!T* t) pure nothrow {
    return t ? t.v ~ preOrder(t.l) ~ preOrder(t.r) : [];
}

T[] inOrder(T)(in Node!T* t) pure nothrow {
    return t ? inOrder(t.l) ~ t.v ~ inOrder(t.r) : [];
}

T[] postOrder(T)(in Node!T* t) pure nothrow {
    return t ? postOrder(t.l) ~ postOrder(t.r) ~ t.v : [];
}

T[] levelOrder(T)(in Node!T* t) pure nothrow {
    static T[] loop(in Node!T*[] a) pure nothrow {
        if (!a.length) return [];
        if (!a[0]) return loop(a[1 .. $]);
        return a[0].v ~ loop(a[1 .. $] ~ [a[0].l, a[0].r]);
    }
    return loop([t]);
}

void main() {
    alias N = Node!int;
    auto tree = new N(1,
                     new N(2,
                          new N(4,
                               new N(7)),
                          new N(5)),
                     new N(3,
                          new N(6,
                               new N(8),
                               new N(9))));

    import std.stdio;
    writeln(preOrder(tree));
    writeln(inOrder(tree));
    writeln(postOrder(tree));
    writeln(levelOrder(tree));
}
