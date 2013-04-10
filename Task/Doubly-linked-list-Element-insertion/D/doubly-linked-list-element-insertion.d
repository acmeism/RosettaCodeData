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

void show(T)(Node!(T)* list) {
    while (list) {
        write(list.data, " ");
        list = list.next;
    }
    writeln();
}

/// If prev is null, prev gets to point to a new node
void insertAfter(T)(ref Node!(T)* prev, T item) {
    if (prev) {
        auto newNode = new Node!T(item, prev, prev.next);
        prev.next = newNode;
        if (newNode.next)
            newNode.next.prev = newNode;
    } else
        prev = new Node!T(item);
}

void main() {
    Node!(string)* list;
    insertAfter(list, "A");
    show(list);
    insertAfter(list, "B");
    show(list);
    insertAfter(list, "C");
    show(list);
}
