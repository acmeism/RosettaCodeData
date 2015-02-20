import std.stdio, std.traits;

const final class Node(T) {
    T data;
    Node left, right;

    this(in T data, in Node left=null, in Node right=null)
    const pure nothrow {
        this.data = data;
        this.left = left;
        this.right = right;
    }
}

// 'static' templated opCall can't be used in Node
auto node(T)(in T data, in Node!T left=null, in Node!T right=null)
pure nothrow {
    return new const(Node!T)(data, left, right);
}

void show(T)(in T x) {
    write(x, " ");
}

enum Visit { pre, inv, post }

// 'visitor' can be any kind of callable or it uses a default visitor.
// TNode can be any kind of Node, with data, left and right fields,
// so this is more generic than a member function of Node.
void backtrackingOrder(Visit v, TNode, TyF=void*)
                      (in TNode node, TyF visitor=null) {
    alias trueVisitor = Select!(is(TyF == void*), show, visitor);
    if (node !is null) {
        static if (v == Visit.pre)
            trueVisitor(node.data);
        backtrackingOrder!v(node.left, visitor);
        static if (v == Visit.inv)
            trueVisitor(node.data);
        backtrackingOrder!v(node.right, visitor);
        static if (v == Visit.post)
            trueVisitor(node.data);
    }
}

void levelOrder(TNode, TyF=void*)
               (in TNode node, TyF visitor=null, const(TNode)[] more=[]) {
    alias trueVisitor = Select!(is(TyF == void*), show, visitor);
    if (node !is null) {
        more ~= [node.left, node.right];
        trueVisitor(node.data);
    }
    if (more.length)
        levelOrder(more[0], visitor, more[1 .. $]);
}

void main() {
    alias N = node;
    const tree = N(1,
                      N(2,
                           N(4,
                                N(7)),
                           N(5)),
                      N(3,
                           N(6,
                                N(8),
                                N(9))));

    write("  preOrder: ");
    tree.backtrackingOrder!(Visit.pre);
    write("\n   inorder: ");
    tree.backtrackingOrder!(Visit.inv);
    write("\n postOrder: ");
    tree.backtrackingOrder!(Visit.post);
    write("\nlevelorder: ");
    tree.levelOrder;
    writeln;
}
