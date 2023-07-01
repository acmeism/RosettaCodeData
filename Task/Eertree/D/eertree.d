import std.array;
import std.stdio;

void main() {
    auto tree = eertree("eertree");
    writeln(subPalindromes(tree));
}

struct Node {
    int length;
    int[char] edges;
    int suffix;
}

const evenRoot = 0;
const oddRoot = 1;

Node[] eertree(string s) {
    Node[] tree = [
        Node(0, null, oddRoot),
        Node(-1, null, oddRoot),
    ];
    int suffix = oddRoot;
    int n, k;
    foreach (i, c; s) {
        for (n=suffix; ; n=tree[n].suffix) {
            k = tree[n].length;
            int b = i-k-1;
            if (b>=0 && s[b]==c) {
                break;
            }
        }
        if (c in tree[n].edges) {
            suffix = tree[n].edges[c];
            continue;
        }
        suffix = tree.length;
        tree ~= Node(k+2);
        tree[n].edges[c] = suffix;
        if (tree[suffix].length == 1) {
            tree[suffix].suffix = 0;
            continue;
        }
        while (true) {
            n = tree[n].suffix;
            int b = i-tree[n].length-1;
            if (b>=0 && s[b]==c) {
                break;
            }
        }
        tree[suffix].suffix = tree[n].edges[c];
    }
    return tree;
}

auto subPalindromes(Node[] tree) {
    auto s = appender!(string[]);
    void children(int n, string p) {
        foreach (c, n; tree[n].edges) {
            p = c ~ p ~ c;
            s ~= p;
            children(n, p);
        }
    }
    children(0, "");
    foreach (c, n; tree[1].edges) {
        string ct = [c].idup;
        s ~= ct;
        children(n, ct);
    }
    return s.data;
}
