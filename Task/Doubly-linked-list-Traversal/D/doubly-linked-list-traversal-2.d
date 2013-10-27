struct Node(T) {
    T data;
    typeof(this)* prev, next;
}

void prepend(T)(ref Node!T* head, in T item) pure nothrow {
    auto newNode = new Node!T(item, null, head);
    if (head)
        head.prev = newNode;
    head = newNode;
}

void main() {
    import std.stdio;

    Node!char* head;
    foreach (char c; "DCBA")
        head.prepend(c);

    auto last = head;
    for (auto p = head; p; p = p.next) {
        p.data.write;
        last = p;
    }
    writeln;

    for (auto p = last; p; p = p.prev)
        p.data.write;
    writeln;
}
