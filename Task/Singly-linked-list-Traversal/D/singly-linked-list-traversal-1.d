struct SLinkedNode(T) {
    T data;
    typeof(this)* next;
}

void main() {
    import std.stdio;

    alias N = SLinkedNode!int;
    auto lh = new N(1, new N(2, new N(3, new N(4))));

    for (auto p = lh; p; p = p.next)
        write(p.data, " ");
    writeln();
}
