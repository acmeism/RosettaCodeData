using System;
using System.Collections.Generic;

namespace Eertree {
    class Node {
        public Node(int length) {
            this.Length = length;
            // empty or
            this.Edges = new Dictionary<char, int>();
        }

        public Node(int length, Dictionary<char, int> edges, int suffix) {
            this.Length = length;
            this.Edges = edges;
            this.Suffix = suffix;
        }

        public int Length { get; set; }
        public Dictionary<char, int> Edges { get; set; }
        public int Suffix { get; set; }
    }

    class Program {
        const int EVEN_ROOT = 0;
        const int ODD_ROOT = 1;

        static List<Node> Eertree(string s) {
            List<Node> tree = new List<Node> {
                //new Node(0, null, ODD_ROOT), or
                new Node(0, new Dictionary<char, int>(), ODD_ROOT),
                //new Node(-1, null, ODD_ROOT) or
                new Node(-1, new Dictionary<char, int>(), ODD_ROOT)
            };
            int suffix = ODD_ROOT;
            int n, k;
            for (int i = 0; i < s.Length; i++) {
                char c = s[i];
                for (n = suffix; ; n = tree[n].Suffix) {
                    k = tree[n].Length;
                    int b = i - k - 1;
                    if (b >= 0 && s[b] == c) {
                        break;
                    }
                }
                if (tree[n].Edges.ContainsKey(c)) {
                    suffix = tree[n].Edges[c];
                    continue;
                }
                suffix = tree.Count;
                tree.Add(new Node(k + 2));
                tree[n].Edges[c] = suffix;
                if (tree[suffix].Length == 1) {
                    tree[suffix].Suffix = 0;
                    continue;
                }
                while (true) {
                    n = tree[n].Suffix;
                    int b = i - tree[n].Length - 1;
                    if (b >= 0 && s[b] == c) {
                        break;
                    }
                }
                tree[suffix].Suffix = tree[n].Edges[c];
            }
            return tree;
        }

        static List<string> SubPalindromes(List<Node> tree) {
            List<string> s = new List<string>();
            SubPalindromes_children(0, "", tree, s);
            foreach (var c in tree[1].Edges.Keys) {
                int m = tree[1].Edges[c];
                string ct = c.ToString();
                s.Add(ct);
                SubPalindromes_children(m, ct, tree, s);
            }
            return s;
        }

        static void SubPalindromes_children(int n, string p, List<Node> tree, List<string> s) {
            foreach (var c in tree[n].Edges.Keys) {
                int m = tree[n].Edges[c];
                string p1 = c + p + c;
                s.Add(p1);
                SubPalindromes_children(m, p1, tree, s);
            }
        }

        static void Main(string[] args) {
            List<Node> tree = Eertree("eertree");
            List<string> result = SubPalindromes(tree);
            string listStr = string.Join(", ", result);
            Console.WriteLine("[{0}]", listStr);
        }
    }
}
