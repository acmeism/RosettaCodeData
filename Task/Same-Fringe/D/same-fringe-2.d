import std.array: empty;
import std.algorithm: equal;


// Replace with an efficient stack when available in Phobos.
struct Stack(T) {
    private T[] data;

    public @property bool empty() const pure nothrow {
        return data.empty;
    }

    // Can't be const if T isn't a value or const.
    public @property T head() const pure nothrow
    in {
        assert(!data.empty);
    } body {
        return data[$ - 1];
    }

    public void push(T x) pure nothrow {
        data ~= x;
    }

    public void pop() pure nothrow
    in {
        assert(!data.empty);
    } body {
        data.length--;
    }
}


struct BinaryTreeNode(T) {
    T data;
    BinaryTreeNode* left, right;
}


struct Fringe(T) {
    alias const(BinaryTreeNode!T)* BT;
    private Stack!BT stack;

    pure nothrow invariant() {
        assert(stack.empty || isLeaf(stack.head));
    }

    public this(BT t) pure nothrow {
        if (t != null) {
            stack.push(t);
            if (!isLeaf(t)) {
                // Here invariant() doesn't hold.
                // invariant() isn't called for private methods.
                nextLeaf();
            }
        }
    }

    public @property bool empty() const pure nothrow {
        return stack.empty;
    }

    public @property T front() const pure nothrow
    in {
        assert(!stack.empty && stack.head != null);
    } body {
        return stack.head.data;
    }

    public void popFront() pure nothrow
    in {
        assert(!stack.empty);
    } body {
        stack.pop();
        if (!empty())
            nextLeaf();
    }

    private static bool isLeaf(in BT t) pure nothrow {
        return t != null && t.left == null && t.right == null;
    }

    private void nextLeaf() pure nothrow
    in {
        assert(!stack.empty);
    } body {
        auto t = stack.head;

        while (!stack.empty && !isLeaf(t)) {
            stack.pop();
            if (t.right != null)
                stack.push(t.right);
            if (t.left != null)
                stack.push(t.left);
            t = stack.head;
        }
    }
}


bool sameFringe(T)(in BinaryTreeNode!T* t1, in BinaryTreeNode!T* t2)
pure nothrow {
    return Fringe!T(t1).equal(Fringe!T(t2));
}


unittest {
    alias BinaryTreeNode!int N;

    static N* n(in int x, N* l=null, N* r=null) pure nothrow {
        return new N(x, l, r);
    }

    {
        N* t;
        assert(sameFringe(t, t));
    }

    {
        const t1 = n(10);
        const t2 = n(10);
        assert(sameFringe(t1, t2));
    }

    {
        const t1 = n(10);
        const t2 = n(20);
        assert(!sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20));
        const t2 = n(30, n(20));
        assert(sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20));
        const t2 = n(10, n(30));
        assert(!sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20), n(30));
        const t2 = n(5, n(20), n(30));
        assert(sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20), n(30));
        const t2 = n(5, n(20), n(35));
        assert(!sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20, n(30)));
        const t2 = n(1, n(2, n(30)));
        assert(sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20, n(30, n(40), n(50))));
        const t2 = n(1, n(2, n(3, n(40), n(50))));
        assert(sameFringe(t1, t2));
    }

    {
        const t1 = n(10, n(20, n(30, n(40), n(50))));
        const t2 = n(1, n(2, n(3, n(40), n(51))));
        assert(!sameFringe(t1, t2));
    }
}


void main() {
    import std.stdio;
    alias N = BinaryTreeNode!int;

    static N* n(in int x, N* l=null, N* r=null) pure nothrow {
        return new N(x, l, r);
    }

    const t1 = n(10, n(20, n(30, n(40), n(50))));
    writeln("fringe(t1): ", Fringe!int(t1));

    const t2 = n(1, n(2, n(3, n(40), n(50))));
    writeln("fringe(t2): ", Fringe!int(t2));

    const t3 = n(1, n(2, n(3, n(40), n(51))));
    writeln("fringe(t3): ", Fringe!int(t3));

    writeln("sameFringe(t1, t2): ", sameFringe(t1, t2));
    writeln("sameFringe(t1, t3): ", sameFringe(t1, t3));
}
