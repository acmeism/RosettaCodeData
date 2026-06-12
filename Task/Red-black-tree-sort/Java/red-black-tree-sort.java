// RBTree class represents a Red-Black Tree
class RBTree {
    private Node nullNode;
    private Node root;

    // Constructor creates a new Red-Black Tree
    public RBTree() {
        this.nullNode = new Node(); // Creates null node with default values
        this.root = this.nullNode;
    }

    // Creates a new node with the given value
    private Node newNode(int val) {
        Node node = new Node(val);
        node.left = this.nullNode;
        node.right = this.nullNode;
        return node;
    }

    // Inserts a new node with the given key
    public void insertNode(int key) {
        Node node = newNode(key);
        node.parent = null;
        node.left = this.nullNode;
        node.right = this.nullNode;
        node.color = 1; // Red

        Node y = null;
        Node x = this.root;

        while (x != this.nullNode) {
            y = x;
            if (node.val < x.val) {
                x = x.left;
            } else {
                x = x.right;
            }
        }

        node.parent = y;
        if (y == null) {
            this.root = node;
        } else if (node.val < y.val) {
            y.left = node;
        } else {
            y.right = node;
        }

        if (node.parent == null) {
            node.color = 0; // Black
            return;
        }

        if (node.parent.parent == null) {
            return;
        }

        fixInsert(node);
    }

    // Finds the node with the minimum value in the subtree rooted at node
    private Node minimum(Node node) {
        while (node.left != this.nullNode) {
            node = node.left;
        }
        return node;
    }

    // Performs a left rotation on the given node
    private void leftRotate(Node x) {
        Node y = x.right;
        x.right = y.left;
        if (y.left != this.nullNode) {
            y.left.parent = x;
        }

        y.parent = x.parent;
        if (x.parent == null) {
            this.root = y;
        } else if (x == x.parent.left) {
            x.parent.left = y;
        } else {
            x.parent.right = y;
        }
        y.left = x;
        x.parent = y;
    }

    // Performs a right rotation on the given node
    private void rightRotate(Node x) {
        Node y = x.left;
        x.left = y.right;
        if (y.right != this.nullNode) {
            y.right.parent = x;
        }

        y.parent = x.parent;
        if (x.parent == null) {
            this.root = y;
        } else if (x == x.parent.right) {
            x.parent.right = y;
        } else {
            x.parent.left = y;
        }
        y.right = x;
        x.parent = y;
    }

    // Fixes the Red-Black Tree after insertion
    private void fixInsert(Node k) {
        while (k.parent.color == 1) {
            if (k.parent == k.parent.parent.right) {
                Node u = k.parent.parent.left;
                if (u.color == 1) {
                    u.color = 0;
                    k.parent.color = 0;
                    k.parent.parent.color = 1;
                    k = k.parent.parent;
                } else {
                    if (k == k.parent.left) {
                        k = k.parent;
                        rightRotate(k);
                    }
                    k.parent.color = 0;
                    k.parent.parent.color = 1;
                    leftRotate(k.parent.parent);
                }
            } else {
                Node u = k.parent.parent.right;
                if (u.color == 1) {
                    u.color = 0;
                    k.parent.color = 0;
                    k.parent.parent.color = 1;
                    k = k.parent.parent;
                } else {
                    if (k == k.parent.right) {
                        k = k.parent;
                        leftRotate(k);
                    }
                    k.parent.color = 0;
                    k.parent.parent.color = 1;
                    rightRotate(k.parent.parent);
                }
            }
            if (k == this.root) {
                break;
            }
        }
        this.root.color = 0;
    }

    // Fixes the Red-Black Tree after deletion
    private void fixDelete(Node x) {
        while (x != this.root && x.color == 0) {
            if (x == x.parent.left) {
                Node s = x.parent.right;
                if (s.color == 1) {
                    s.color = 0;
                    x.parent.color = 1;
                    leftRotate(x.parent);
                    s = x.parent.right;
                }

                if (s.left.color == 0 && s.right.color == 0) {
                    s.color = 1;
                    x = x.parent;
                } else {
                    if (s.right.color == 0) {
                        s.left.color = 0;
                        s.color = 1;
                        rightRotate(s);
                        s = x.parent.right;
                    }

                    s.color = x.parent.color;
                    x.parent.color = 0;
                    s.right.color = 0;
                    leftRotate(x.parent);
                    x = this.root;
                }
            } else {
                Node s = x.parent.left;
                if (s.color == 1) {
                    s.color = 0;
                    x.parent.color = 1;
                    rightRotate(x.parent);
                    s = x.parent.left;
                }

                if (s.right.color == 0 && s.left.color == 0) {
                    s.color = 1;
                    x = x.parent;
                } else {
                    if (s.left.color == 0) {
                        s.right.color = 0;
                        s.color = 1;
                        leftRotate(s);
                        s = x.parent.left;
                    }

                    s.color = x.parent.color;
                    x.parent.color = 0;
                    s.left.color = 0;
                    rightRotate(x.parent);
                    x = this.root;
                }
            }
        }
        x.color = 0;
    }

    // Replaces one subtree with another
    private void rbTransplant(Node u, Node v) {
        if (u.parent == null) {
            this.root = v;
        } else if (u == u.parent.left) {
            u.parent.left = v;
        } else {
            u.parent.right = v;
        }
        v.parent = u.parent;
    }

    // Helper function for deleteNode
    private void deleteNodeHelper(Node node, int key) {
        Node z = this.nullNode;
        Node temp = node;

        while (temp != this.nullNode) {
            if (temp.val == key) {
                z = temp;
            }

            if (temp.val <= key) {
                temp = temp.right;
            } else {
                temp = temp.left;
            }
        }

        if (z == this.nullNode) {
            System.out.println("Value not present in Tree !!");
            return;
        }

        Node y = z;
        int yOriginalColor = y.color;
        Node x;

        if (z.left == this.nullNode) {
            x = z.right;
            rbTransplant(z, z.right);
        } else if (z.right == this.nullNode) {
            x = z.left;
            rbTransplant(z, z.left);
        } else {
            y = minimum(z.right);
            yOriginalColor = y.color;
            x = y.right;
            if (y.parent == z) {
                x.parent = y;
            } else {
                rbTransplant(y, y.right);
                y.right = z.right;
                y.right.parent = y;
            }

            rbTransplant(z, y);
            y.left = z.left;
            y.left.parent = y;
            y.color = z.color;
        }

        if (yOriginalColor == 0) {
            fixDelete(x);
        }
    }

    // Deletes a node with the given value
    public void deleteNode(int val) {
        deleteNodeHelper(this.root, val);
    }

    // Recursively prints the tree
    private void printCall(Node node, String indent, boolean last) {
        if (node != this.nullNode) {
            System.out.print(indent);
            if (last) {
                System.out.print("R----");
                indent += "     ";
            } else {
                System.out.print("L----");
                indent += "|    ";
            }

            String sColor = (node.color == 1) ? "RED" : "BLACK";
            System.out.printf("%d(%s)%n", node.val, sColor);
            printCall(node.left, indent, false);
            printCall(node.right, indent, true);
        }
    }

    // Prints the entire tree
    public void printTree() {
        printCall(this.root, "", true);
    }

    // Main method for testing
    public static void main(String[] args) {
        RBTree bst = new RBTree();

        System.out.println("State of the tree after inserting the 30 keys:");
        for (int x = 1; x < 30; x++) {
            bst.insertNode(x);
        }
        bst.printTree();

        System.out.println("\nState of the tree after deleting the 15 keys:");
        for (int x = 1; x < 15; x++) {
            bst.deleteNode(x);
        }
        bst.printTree();
    }
}


// Node class represents a node in the Red-Black Tree
class Node {
    int val;
    Node parent;
    Node left;
    Node right;
    int color; // 1 for Red, 0 for Black

    public Node(int val) {
        this.val = val;
        this.parent = null;
        this.left = null;
        this.right = null;
        this.color = 1; // Red
    }

    // Constructor for null node
    public Node() {
        this.val = 0;
        this.color = 0; // Black
        this.left = null;
        this.right = null;
        this.parent = null;
    }
}
