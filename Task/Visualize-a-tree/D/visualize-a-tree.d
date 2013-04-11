import std.stdio, std.conv, std.algorithm, std.array;

struct BTNode(T) { T value; BTNode* left, right; }

string[] treeIndent(T)(in BTNode!T* t) {
    if (t is null) return ["-- (null)"];
    const tr = treeIndent(t.right);
    return text("--", t.value) ~
           map!q{"  |" ~ a}(treeIndent(t.left)).array() ~
           ("  `" ~ tr[0]) ~ map!q{"   " ~ a}(tr[1..$]).array();
}

void main () {
    static N(T)(T v, BTNode!T* l=null, BTNode!T* r=null) {
        return new BTNode!T(v, l, r);
    }

    const tree = N(1, N(2, N(4, N(7)), N(5)), N(3, N(6, N(8), N(9))));
    writefln("%-(%s\n%)", tree.treeIndent());
}
