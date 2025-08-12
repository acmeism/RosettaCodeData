class Node {
    int key;
    int balance = 0;
    int height = 0;
    Node? left;
    Node? right;
    Node? parent;

    Node(this.key, this.parent);
}




class AVLTree {
  Node? root;

  bool insert(int key) {
    if (root == null) {
      root = Node(key, null);
      return true;
    }

    Node? n = root;
    while (true) {
      if (n!.key == key) return false;

      Node parent = n;

      bool goLeft = n.key > key;
      n = goLeft ? n.left : n.right;

      if (n == null) {
        if (goLeft) {
          parent.left = Node(key, parent);
        } else {
          parent.right = Node(key, parent);
        }
        rebalance(parent);
        break;
      }
    }
    return true;
  }

  void _delete(Node node) {
    if (node.left == null && node.right == null) {
      if (node.parent == null) {
        root = null;
      } else {
        Node parent = node.parent!;
        if (parent.left == node) {
          parent.left = null;
        } else {
          parent.right = null;
        }
        rebalance(parent);
      }
      return;
    }

    if (node.left != null) {
      Node child = node.left!;
      while (child.right != null) child = child.right!;
      node.key = child.key;
      _delete(child);
    } else {
      Node child = node.right!;
      while (child.left != null) child = child.left!;
      node.key = child.key;
      _delete(child);
    }
  }

  void delete(int delKey) {
    if (root == null) return;

    Node? child = root;
    while (child != null) {
      Node node = child;
      child = delKey >= node.key ? node.right : node.left;
      if (delKey == node.key) {
        _delete(node);
        return;
      }
    }
  }

  void rebalance(Node n) {
    setBalance(n);

    if (n.balance == -2) {
      if (height(n.left!.left) >= height(n.left!.right)) {
        n = rotateRight(n);
      } else {
        n = rotateLeftThenRight(n);
      }
    } else if (n.balance == 2) {
      if (height(n.right!.right) >= height(n.right!.left)) {
        n = rotateLeft(n);
      } else {
        n = rotateRightThenLeft(n);
      }
    }

    if (n.parent != null) {
      rebalance(n.parent!);
    } else {
      root = n;
    }
  }

  Node rotateLeft(Node a) {
    Node b = a.right!;
    b.parent = a.parent;

    a.right = b.left;

    if (a.right != null) a.right!.parent = a;

    b.left = a;
    a.parent = b;

    if (b.parent != null) {
      if (b.parent!.right == a) {
        b.parent!.right = b;
      } else {
        b.parent!.left = b;
      }
    }

    setBalance(a, b);

    return b;
  }

  Node rotateRight(Node a) {
    Node b = a.left!;
    b.parent = a.parent;

    a.left = b.right;

    if (a.left != null) a.left!.parent = a;

    b.right = a;
    a.parent = b;

    if (b.parent != null) {
      if (b.parent!.right == a) {
        b.parent!.right = b;
      } else {
        b.parent!.left = b;
      }
    }

    setBalance(a, b);

    return b;
  }

  Node rotateLeftThenRight(Node n) {
    n.left = rotateLeft(n.left!);
    return rotateRight(n);
  }

  Node rotateRightThenLeft(Node n) {
    n.right = rotateRight(n.right!);
    return rotateLeft(n);
  }

  int height(Node? n) {
    if (n == null) return -1;
    return n.height;
  }

  void setBalance(Node n, [Node? n2]) {
    reheight(n);
    n.balance = height(n.right) - height(n.left);

    if (n2 != null) {
      reheight(n2);
      n2.balance = height(n2.right) - height(n2.left);
    }
  }

  void printBalance() {
    _printBalance(root);
  }

  void _printBalance(Node? n) {
    if (n != null) {
      _printBalance(n.left);
      print('${n.balance} ');
      _printBalance(n.right);
    }
  }

  void reheight(Node node) {
    if (node != null) {
      node.height = 1 + (height(node.left) > height(node.right)
          ? height(node.left)
          : height(node.right));
    }
  }

  static void main() {
    AVLTree tree = AVLTree();

    print('Inserting values 1 to 10');
    for (int i = 1; i < 10; i++) {
      tree.insert(i);
    }

    print('Printing balance: ');
    tree.printBalance();
  }
}

void main() {
  AVLTree.main();
}
