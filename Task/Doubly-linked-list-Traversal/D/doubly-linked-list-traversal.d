import std.stdio;

struct Node(T) {
    T data;
    Node* prev, next;

    this(T data_, Node* prev_=null, Node* next_=null) {
        data = data_;
        prev = prev_;
        next = next_;
    }
}

void prepend(T)(ref Node!(T)* head, T item) {
    auto newNode = new Node!T(item, null, head);
    if (head)
        head.prev = newNode;
    head = newNode;
}

void main() {
    Node!(string)* head;
    prepend(head, "D");
    prepend(head, "C");
    prepend(head, "B");
    prepend(head, "A");

    auto p = head;
    auto last = p;
    while (p) {
        write(p.data, " ");
        last = p;
        p = p.next;
    }
    writeln();

    while (last) {
        write(last.data, " ");
        last = last.prev;
    }
    writeln();
}
