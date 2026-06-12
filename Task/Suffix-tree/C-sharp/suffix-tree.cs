using System;
using System.Collections.Generic;

namespace SuffixTree {
    class Node {
        public string sub;                     // a substring of the input string
        public List<int> ch = new List<int>(); // vector of child nodes

        public Node() {
            sub = "";
        }

        public Node(string sub, params int[] children) {
            this.sub = sub;
            ch.AddRange(children);
        }
    }

    class SuffixTree {
        readonly List<Node> nodes = new List<Node>();

        public SuffixTree(string str) {
            nodes.Add(new Node());
            for (int i = 0; i < str.Length; i++) {
                AddSuffix(str.Substring(i));
            }
        }

        public void Visualize() {
            if (nodes.Count == 0) {
                Console.WriteLine("<empty>");
                return;
            }

            void f(int n, string pre) {
                var children = nodes[n].ch;
                if (children.Count == 0) {
                    Console.WriteLine("- {0}", nodes[n].sub);
                    return;
                }
                Console.WriteLine("+ {0}", nodes[n].sub);

                var it = children.GetEnumerator();
                if (it.MoveNext()) {
                    do {
                        var cit = it;
                        if (!cit.MoveNext()) break;

                        Console.Write("{0}+-", pre);
                        f(it.Current, pre + "| ");
                    } while (it.MoveNext());
                }

                Console.Write("{0}+-", pre);
                f(children[children.Count-1], pre+"  ");
            }

            f(0, "");
        }

        private void AddSuffix(string suf) {
            int n = 0;
            int i = 0;
            while (i < suf.Length) {
                char b = suf[i];
                int x2 = 0;
                int n2;
                while (true) {
                    var children = nodes[n].ch;
                    if (x2 == children.Count) {
                        // no matching child, remainder of suf becomes new node
                        n2 = nodes.Count;
                        nodes.Add(new Node(suf.Substring(i)));
                        nodes[n].ch.Add(n2);
                        return;
                    }
                    n2 = children[x2];
                    if (nodes[n2].sub[0] == b) {
                        break;
                    }
                    x2++;
                }
                // find prefix of remaining suffix in common with child
                var sub2 = nodes[n2].sub;
                int j = 0;
                while (j < sub2.Length) {
                    if (suf[i + j] != sub2[j]) {
                        // split n2
                        var n3 = n2;
                        // new node for the part in common
                        n2 = nodes.Count;
                        nodes.Add(new Node(sub2.Substring(0, j), n3));
                        nodes[n3].sub = sub2.Substring(j); // old node loses the part in common
                        nodes[n].ch[x2] = n2;
                        break; // continue down the tree
                    }
                    j++;
                }
                i += j; // advance past part in common
                n = n2; // continue down the tree
            }
        }
    }

    class Program {
        static void Main() {
            new SuffixTree("banana$").Visualize();
        }
    }
}
