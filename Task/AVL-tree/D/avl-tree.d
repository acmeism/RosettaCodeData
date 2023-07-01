import std.stdio, std.algorithm;

class AVLtree {
    private Node* root;

    private static struct Node {
        private int key, balance;
        private Node* left, right, parent;

        this(in int k, Node* p) pure nothrow @safe @nogc {
            key = k;
            parent = p;
        }
    }

    public bool insert(in int key) pure nothrow @safe {
        if (root is null)
            root = new Node(key, null);
        else {
            Node* n = root;
            Node* parent;
            while (true) {
                if (n.key == key)
                    return false;

                parent = n;

                bool goLeft = n.key > key;
                n = goLeft ? n.left : n.right;

                if (n is null) {
                    if (goLeft) {
                        parent.left = new Node(key, parent);
                    } else {
                        parent.right = new Node(key, parent);
                    }
                    rebalance(parent);
                    break;
                }
            }
        }
        return true;
    }

    public void deleteKey(in int delKey) pure nothrow @safe @nogc {
        if (root is null)
            return;
        Node* n = root;
        Node* parent = root;
        Node* delNode = null;
        Node* child = root;

        while (child !is null) {
            parent = n;
            n = child;
            child = delKey >= n.key ? n.right : n.left;
            if (delKey == n.key)
                delNode = n;
        }

        if (delNode !is null) {
            delNode.key = n.key;

            child = n.left !is null ? n.left : n.right;

            if (root.key == delKey) {
                root = child;
            } else {
                if (parent.left is n) {
                    parent.left = child;
                } else {
                    parent.right = child;
                }
                rebalance(parent);
            }
        }
    }

    private void rebalance(Node* n) pure nothrow @safe @nogc {
        setBalance(n);

        if (n.balance == -2) {
            if (height(n.left.left) >= height(n.left.right))
                n = rotateRight(n);
            else
                n = rotateLeftThenRight(n);

        } else if (n.balance == 2) {
            if (height(n.right.right) >= height(n.right.left))
                n = rotateLeft(n);
            else
                n = rotateRightThenLeft(n);
        }

        if (n.parent !is null) {
            rebalance(n.parent);
        } else {
            root = n;
        }
    }

    private Node* rotateLeft(Node* a) pure nothrow @safe @nogc {
        Node* b = a.right;
        b.parent = a.parent;

        a.right = b.left;

        if (a.right !is null)
            a.right.parent = a;

        b.left = a;
        a.parent = b;

        if (b.parent !is null) {
            if (b.parent.right is a) {
                b.parent.right = b;
            } else {
                b.parent.left = b;
            }
        }

        setBalance(a, b);

        return b;
    }

    private Node* rotateRight(Node* a) pure nothrow @safe @nogc {
        Node* b = a.left;
        b.parent = a.parent;

        a.left = b.right;

        if (a.left !is null)
            a.left.parent = a;

        b.right = a;
        a.parent = b;

        if (b.parent !is null) {
            if (b.parent.right is a) {
                b.parent.right = b;
            } else {
                b.parent.left = b;
            }
        }

        setBalance(a, b);

        return b;
    }

    private Node* rotateLeftThenRight(Node* n) pure nothrow @safe @nogc {
        n.left = rotateLeft(n.left);
        return rotateRight(n);
    }

    private Node* rotateRightThenLeft(Node* n) pure nothrow @safe @nogc {
        n.right = rotateRight(n.right);
        return rotateLeft(n);
    }

    private int height(in Node* n) const pure nothrow @safe @nogc {
        if (n is null)
            return -1;
        return 1 + max(height(n.left), height(n.right));
    }

    private void setBalance(Node*[] nodes...) pure nothrow @safe @nogc {
        foreach (n; nodes)
            n.balance = height(n.right) - height(n.left);
    }

    public void printBalance() const @safe {
        printBalance(root);
    }

    private void printBalance(in Node* n) const @safe {
        if (n !is null) {
            printBalance(n.left);
            write(n.balance, ' ');
            printBalance(n.right);
        }
    }
}

void main() @safe {
    auto tree = new AVLtree();

    writeln("Inserting values 1 to 10");
    foreach (immutable i; 1 .. 11)
        tree.insert(i);

    write("Printing balance: ");
    tree.printBalance;
}
