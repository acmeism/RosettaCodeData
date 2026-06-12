import 'dart:io';

class Node {
  String sub = "";
  List<int> ch = [];
}

class SuffixTree {
  List<Node> nodes = [];

  SuffixTree(String str) {
    nodes.add(Node());
    for (int i = 0; i < str.length; i++) {
      addSuffix(str.substring(i));
    }
  }

  void addSuffix(String suf) {
    int n = 0;
    int i = 0;

    while (i < suf.length) {
      String b = suf[i];
      List<int> children = nodes[n].ch;
      int x2 = 0;
      int n2;

      while (true) {
        if (x2 == children.length) {
          // no matching child, remainder of suf becomes new node.
          n2 = nodes.length;
          Node temp = Node();
          temp.sub = suf.substring(i);
          nodes.add(temp);
          children.add(n2);
          return;
        }
        n2 = children[x2];
        if (nodes[n2].sub[0] == b) break;
        x2++;
      }

      // find prefix of remaining suffix in common with child
      String sub2 = nodes[n2].sub;
      int j = 0;

      while (j < sub2.length) {
        if (suf[i + j] != sub2[j]) {
          // split n2
          int n3 = n2;
          // new node for the part in common
          n2 = nodes.length;
          Node temp = Node();
          temp.sub = sub2.substring(0, j);
          temp.ch.add(n3);
          nodes.add(temp);
          nodes[n3].sub = sub2.substring(j); // old node loses the part in common
          nodes[n].ch[x2] = n2;
          break; // continue down the tree
        }
        j++;
      }
      i += j; // advance past part in common
      n = n2; // continue down the tree
    }
  }

  void visualize() {
    if (nodes.isEmpty) {
      print("<empty>");
      return;
    }
    visualizeF(0, "");
  }

  void visualizeF(int n, String pre) {
    List<int> children = nodes[n].ch;

    if (children.isEmpty) {
      print("- ${nodes[n].sub}");
      return;
    }

    print("┐ ${nodes[n].sub}");

    for (int i = 0; i < children.length - 1; i++) {
      int c = children[i];
      stdout.write("$pre├─");
      visualizeF(c, "$pre│ ");
    }

    stdout.write("$pre└─");
    visualizeF(children[children.length - 1], "$pre  ");
  }
}

void main() {
  SuffixTree("banana\$").visualize();
}
