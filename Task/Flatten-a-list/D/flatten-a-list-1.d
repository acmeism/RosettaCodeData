import std.stdio, std.algorithm, std.conv, std.range;

struct TreeList(T) {
    union { // A tagged union
        TreeList[] arr; // it's a node
        T data; // it's a leaf
    }
    bool isArray = true; // = contains an arr on default.

    static TreeList opCall(A...)(A items) /*const*/ pure nothrow {
        TreeList result;

        foreach (i, el; items)
            static if (is(A[i] == T)) {
                TreeList item;
                item.isArray = false;
                item.data = el;
                result.arr ~= item;
            } else
                result.arr ~= el;

        return result;
    }

    string toString() const {
        return isArray ? text(arr) : text(data);
    }
}

T[] flatten(T)(in TreeList!T t) /*pure nothrow*/ {
    if (t.isArray)
        return t.arr.map!flatten().join();
    else
        return [t.data];
}

void main() {
    alias TreeList!int L;
    static assert(L.sizeof == 12);
    auto l = L(L(1), 2, L(L(3,4), 5), L(L(L())), L(L(L(6))),7,8,L());
    writeln(l);
    writeln(flatten(l));
}
