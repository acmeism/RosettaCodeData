// Node class represents a node in the Red-Black Tree
class Node {
  int val;
  Node? parent;
  Node? left;
  Node? right;
  int color; // 1 for Red, 0 for Black

  Node(this.val) : color = 1 {
    parent = null;
    left = null;
    right = null;
  }

  // Constructor for null node
  Node.nullNode() : val = 0, color = 0 {
    left = null;
    right = null;
    parent = null;
  }
}

// RBTree class represents a Red-Black Tree
class RBTree {
  late Node nullNode;
  late Node root;

  // Constructor creates a new Red-Black Tree
  RBTree() {
    nullNode = Node.nullNode(); // Creates null node with default values
    root = nullNode;
  }

  // Creates a new node with the given value
  Node _newNode(int val) {
    Node node = Node(val);
    node.left = nullNode;
    node.right = nullNode;
    return node;
  }

  // Inserts a new node with the given key
  void insertNode(int key) {
    Node node = _newNode(key);
    node.parent = null;
    node.left = nullNode;
    node.right = nullNode;
    node.color = 1; // Red

    Node? y;
    Node x = root;

    while (x != nullNode) {
      y = x;
      if (node.val < x.val) {
        x = x.left!;
      } else {
        x = x.right!;
      }
    }

    node.parent = y;
    if (y == null) {
      root = node;
    } else if (node.val < y.val) {
      y.left = node;
    } else {
      y.right = node;
    }

    if (node.parent == null) {
      node.color = 0; // Black
      return;
    }

    if (node.parent!.parent == null) {
      return;
    }

    _fixInsert(node);
  }

  // Finds the node with the minimum value in the subtree rooted at node
  Node _minimum(Node node) {
    while (node.left != nullNode) {
      node = node.left!;
    }
    return node;
  }

  // Performs a left rotation on the given node
  void _leftRotate(Node x) {
    Node y = x.right!;
    x.right = y.left;
    if (y.left != nullNode) {
      y.left!.parent = x;
    }

    y.parent = x.parent;
    if (x.parent == null) {
      root = y;
    } else if (x == x.parent!.left) {
      x.parent!.left = y;
    } else {
      x.parent!.right = y;
    }
    y.left = x;
    x.parent = y;
  }

  // Performs a right rotation on the given node
  void _rightRotate(Node x) {
    Node y = x.left!;
    x.left = y.right;
    if (y.right != nullNode) {
      y.right!.parent = x;
    }

    y.parent = x.parent;
    if (x.parent == null) {
      root = y;
    } else if (x == x.parent!.right) {
      x.parent!.right = y;
    } else {
      x.parent!.left = y;
    }
    y.right = x;
    x.parent = y;
  }

  // Fixes the Red-Black Tree after insertion
  void _fixInsert(Node k) {
    while (k.parent!.color == 1) {
      if (k.parent == k.parent!.parent!.right) {
        Node u = k.parent!.parent!.left!;
        if (u.color == 1) {
          u.color = 0;
          k.parent!.color = 0;
          k.parent!.parent!.color = 1;
          k = k.parent!.parent!;
        } else {
          if (k == k.parent!.left) {
            k = k.parent!;
            _rightRotate(k);
          }
          k.parent!.color = 0;
          k.parent!.parent!.color = 1;
          _leftRotate(k.parent!.parent!);
        }
      } else {
        Node u = k.parent!.parent!.right!;
        if (u.color == 1) {
          u.color = 0;
          k.parent!.color = 0;
          k.parent!.parent!.color = 1;
          k = k.parent!.parent!;
        } else {
          if (k == k.parent!.right) {
            k = k.parent!;
            _leftRotate(k);
          }
          k.parent!.color = 0;
          k.parent!.parent!.color = 1;
          _rightRotate(k.parent!.parent!);
        }
      }
      if (k == root) {
        break;
      }
    }
    root.color = 0;
  }

  // Fixes the Red-Black Tree after deletion
  void _fixDelete(Node x) {
    while (x != root && x.color == 0) {
      if (x == x.parent!.left) {
        Node s = x.parent!.right!;
        if (s.color == 1) {
          s.color = 0;
          x.parent!.color = 1;
          _leftRotate(x.parent!);
          s = x.parent!.right!;
        }

        if (s.left!.color == 0 && s.right!.color == 0) {
          s.color = 1;
          x = x.parent!;
        } else {
          if (s.right!.color == 0) {
            s.left!.color = 0;
            s.color = 1;
            _rightRotate(s);
            s = x.parent!.right!;
          }

          s.color = x.parent!.color;
          x.parent!.color = 0;
          s.right!.color = 0;
          _leftRotate(x.parent!);
          x = root;
        }
      } else {
        Node s = x.parent!.left!;
        if (s.color == 1) {
          s.color = 0;
          x.parent!.color = 1;
          _rightRotate(x.parent!);
          s = x.parent!.left!;
        }

        if (s.right!.color == 0 && s.left!.color == 0) {
          s.color = 1;
          x = x.parent!;
        } else {
          if (s.left!.color == 0) {
            s.right!.color = 0;
            s.color = 1;
            _leftRotate(s);
            s = x.parent!.left!;
          }

          s.color = x.parent!.color;
          x.parent!.color = 0;
          s.left!.color = 0;
          _rightRotate(x.parent!);
          x = root;
        }
      }
    }
    x.color = 0;
  }

  // Replaces one subtree with another
  void _rbTransplant(Node u, Node v) {
    if (u.parent == null) {
      root = v;
    } else if (u == u.parent!.left) {
      u.parent!.left = v;
    } else {
      u.parent!.right = v;
    }
    v.parent = u.parent;
  }

  // Helper function for deleteNode
  void _deleteNodeHelper(Node node, int key) {
    Node z = nullNode;
    Node temp = node;

    while (temp != nullNode) {
      if (temp.val == key) {
        z = temp;
      }

      if (temp.val <= key) {
        temp = temp.right!;
      } else {
        temp = temp.left!;
      }
    }

    if (z == nullNode) {
      print("Value not present in Tree !!");
      return;
    }

    Node y = z;
    int yOriginalColor = y.color;
    Node x;

    if (z.left == nullNode) {
      x = z.right!;
      _rbTransplant(z, z.right!);
    } else if (z.right == nullNode) {
      x = z.left!;
      _rbTransplant(z, z.left!);
    } else {
      y = _minimum(z.right!);
      yOriginalColor = y.color;
      x = y.right!;
      if (y.parent == z) {
        x.parent = y;
      } else {
        _rbTransplant(y, y.right!);
        y.right = z.right;
        y.right!.parent = y;
      }

      _rbTransplant(z, y);
      y.left = z.left;
      y.left!.parent = y;
      y.color = z.color;
    }

    if (yOriginalColor == 0) {
      _fixDelete(x);
    }
  }

  // Deletes a node with the given value
  void deleteNode(int val) {
    _deleteNodeHelper(root, val);
  }

  // Recursively prints the tree
  void _printCall(Node node, String indent, bool last) {
    if (node != nullNode) {
      print('$indent${last ? "R----" : "L----"}${node.val}(${node.color == 1 ? "RED" : "BLACK"})');
      _printCall(node.left!, '${indent}${last ? "     " : "|    "}', false);
      _printCall(node.right!, '${indent}${last ? "     " : "|    "}', true);
    }
  }

  // Prints the entire tree
  void printTree() {
    _printCall(root, "", true);
  }
}

// Main function for testing
void main() {
  RBTree bst = RBTree();

  print("State of the tree after inserting the 30 keys:");
  for (int x = 1; x < 30; x++) {
    bst.insertNode(x);
  }
  bst.printTree();

  print("\nState of the tree after deleting the 15 keys:");
  for (int x = 1; x < 15; x++) {
    bst.deleteNode(x);
  }
  bst.printTree();
}
