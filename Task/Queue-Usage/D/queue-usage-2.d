module queue_usage2;

import std.traits: hasIndirections;

struct GrowableCircularQueue(T) {
    public size_t length;
    private size_t head, tail;
    private T[] A = [T.init];
    private uint power2 = 0;

    bool empty() const pure nothrow {
        return length == 0;
    }

    void push(immutable T item) pure nothrow {
        if (length >= A.length) { // Double the queue.
            const old = A;
            A = new T[A.length * 2];
            A[0 .. (old.length - head)] = old[head .. $];
            if (head)
                A[(old.length - head) .. old.length] = old[0 .. head];
            head = 0;
            tail = length;
            power2++;
        }
        A[tail] = item;
        tail = (tail + 1) & ((cast(size_t)1 << power2) - 1);
        length++;
    }

    T pop() pure {
        if (length == 0)
            throw new Exception("GrowableCircularQueue is empty.");
        auto saved = A[head];
        static if (hasIndirections!T)
            A[head] = T.init; // Help for the GC.
        head = (head + 1) & ((cast(size_t)1 << power2) - 1);
        length--;
        return saved;
    }
}

version (queue_usage2_main) {
    unittest {
        auto q = new GrowableCircularQueue!int();
        q.push(10);
        q.push(20);
        q.push(30);
        assert(q.pop() == 10);
        assert(q.pop() == 20);
        assert(q.pop() == 30);
        assert(q.empty());

        uint count = 0;
        foreach (immutable i; 1 .. 1_000) {
            foreach (immutable j; 0 .. i)
                q.push(count++);
            foreach (immutable j; 0 .. i)
                q.pop();
        }
    }

    void main() {}
}
