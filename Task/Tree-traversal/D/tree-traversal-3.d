import std.stdio, std.algorithm, std.range, std.string;

const struct Tree(T) {
    T value;
    Tree* left, right;
}

alias VisitRange(T) = InputRange!(const Tree!T);

VisitRange!T preOrder(T)(in Tree!T* t) /*pure nothrow*/ {
    enum self = mixin("&" ~ __FUNCTION__.split(".").back);
    if (t == null)
        return typeof(return).init.takeNone.inputRangeObject;
    return [*t]
           .chain([t.left, t.right]
                  .filter!(t => t != null)
                  .map!(a => self(a))
                  .joiner)
           .inputRangeObject;
}

VisitRange!T inOrder(T)(in Tree!T* t) /*pure nothrow*/ {
    enum self = mixin("&" ~ __FUNCTION__.split(".").back);
    if (t == null)
        return typeof(return).init.takeNone.inputRangeObject;
    return [t.left]
           .filter!(t => t != null)
           .map!(a => self(a))
           .joiner
           .chain([*t])
           .chain([t.right]
                  .filter!(t => t != null)
                  .map!(a => self(a))
                  .joiner)
           .inputRangeObject;
}

VisitRange!T postOrder(T)(in Tree!T* t) /*pure nothrow*/ {
    enum self = mixin("&" ~ __FUNCTION__.split(".").back);
    if (t == null)
        return typeof(return).init.takeNone.inputRangeObject;
    return [t.left, t.right]
           .filter!(t => t != null)
           .map!(a => self(a))
           .joiner
           .chain([*t])
           .inputRangeObject;
}

void main() {
    alias N = Tree!int;
    const tree = new N(1,
                       new N(2,
                             new N(4,
                                   new N(7)),
                             new N(5)),
                       new N(3,
                             new N(6,
                                   new N(8),
                                   new N(9))));

    tree.preOrder.map!(t => t.value).writeln;
    tree.inOrder.map!(t => t.value).writeln;
    tree.postOrder.map!(t => t.value).writeln;
}
