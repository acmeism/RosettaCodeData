class LinkedQueue(T) {
    private static struct Node {
        T data;
        Node* next;
    }

    private Node* head, tail;

    bool empty() { return head is null; }

    void push(T item) {
        if (empty())
            head = tail = new Node(item);
        else {
            tail.next = new Node(item);
            tail = tail.next;
        }
    }

    T pop() {
        if (empty())
            throw new Exception("Empty LinkedQueue.");
        auto item = head.data;
        head = head.next;
        if (head is tail) // Is last one?
            // Release tail reference so that GC can collect.
            tail = null;
        return item;
    }

    alias push enqueue;
    alias pop dequeue;
}

void main() {
    auto q = new LinkedQueue!int();
    q.push(10);
    q.push(20);
    q.push(30);
    assert(q.pop() == 10);
    assert(q.pop() == 20);
    assert(q.pop() == 30);
    assert(q.empty());
}
