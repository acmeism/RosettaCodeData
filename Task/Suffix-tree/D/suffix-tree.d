import std.stdio;

struct Node {
    string sub = ""; // a substring of the input string
    int[] ch;        // array of child nodes

    this(string sub, int[] children ...) {
        this.sub = sub;
        ch = children;
    }
}

struct SuffixTree {
    Node[] nodes;

    this(string str) {
        nodes ~= Node();
        for (int i=0; i<str.length; ++i) {
            addSuffix(str[i..$]);
        }
    }

    private void addSuffix(string suf) {
        int n = 0;
        int i = 0;
        while (i < suf.length) {
            char b  = suf[i];
            int x2 = 0;
            int n2;
            while (true) {
                auto children = nodes[n].ch;
                if (x2 == children.length) {
                    // no matching child, remainder of suf becomes new node.
                    n2 = nodes.length;
                    nodes ~= Node(suf[i..$]);
                    nodes[n].ch ~= n2;
                    return;
                }
                n2 = children[x2];
                if (nodes[n2].sub[0] == b) {
                    break;
                }
                x2++;
            }
            // find prefix of remaining suffix in common with child
            auto sub2 = nodes[n2].sub;
            int j = 0;
            while (j < sub2.length) {
                if (suf[i + j] != sub2[j]) {
                    // split n2
                    auto n3 = n2;
                    // new node for the part in common
                    n2 = nodes.length;
                    nodes ~= Node(sub2[0..j], n3);
                    nodes[n3].sub = sub2[j..$];  // old node loses the part in common
                    nodes[n].ch[x2] = n2;
                    break;  // continue down the tree
                }
                j++;
            }
            i += j;  // advance past part in common
            n = n2;  // continue down the tree
        }
    }

    void visualize() {
        if (nodes.length == 0) {
            writeln("<empty>");
            return;
        }

        void f(int n, string pre) {
            auto children = nodes[n].ch;
            if (children.length == 0) {
                writefln("╴ %s", nodes[n].sub);
                return;
            }
            writefln("┐ %s", nodes[n].sub);
            foreach (c; children[0..$-1]) {
                write(pre, "├─");
                f(c, pre ~ "│ ");
            }
            write(pre, "└─");
            f(children[$-1], pre ~ "  ");
        }

        f(0, "");
    }
}

void main() {
    SuffixTree("banana$").visualize();
}
