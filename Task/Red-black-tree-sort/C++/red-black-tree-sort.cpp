#include <iostream>
#include <string>

// Define Node
struct Node {
    int val;                                   // Value of Node
    Node* parent;                               // Parent of Node
    Node* left;                                 // Left Child of Node
    Node* right;                                // Right Child of Node
    int color;                                   // 1 for Red, 0 for Black
    Node(int val) : val(val), parent(nullptr), left(nullptr), right(nullptr), color(1) {} // Constructor
};

// Define R-B Tree
class RBTree {
public:
    Node* NULL_NODE;
    Node* root;

    RBTree() {
        NULL_NODE = new Node(0);
        NULL_NODE->color = 0;
        NULL_NODE->left = nullptr;
        NULL_NODE->right = nullptr;
        root = NULL_NODE;
    }

    // Insert New Node
    void insertNode(int key) {
        Node* node = new Node(key);
        node->parent = nullptr;
        node->val = key;
        node->left = NULL_NODE;
        node->right = NULL_NODE;
        node->color = 1; // Red

        Node* y = nullptr;
        Node* x = root;

        while (x != NULL_NODE) {
            y = x;
            if (node->val < x->val) {
                x = x->left;
            } else {
                x = x->right;
            }
        }

        node->parent = y;
        if (y == nullptr) {
            root = node;
        } else if (node->val < y->val) {
            y->left = node;
        } else {
            y->right = node;
        }

        if (node->parent == nullptr) {
            node->color = 0;
            return;
        }

        if (node->parent->parent == nullptr) {
            return;
        }

        fixInsert(node);
    }

    Node* minimum(Node* node) {
        while (node->left != NULL_NODE) {
            node = node->left;
        }
        return node;
    }

    // Code for left rotate
    void LR(Node* x) {
        Node* y = x->right;
        x->right = y->left;
        if (y->left != NULL_NODE) {
            y->left->parent = x;
        }

        y->parent = x->parent;
        if (x->parent == nullptr) {
            root = y;
        } else if (x == x->parent->left) {
            x->parent->left = y;
        } else {
            x->parent->right = y;
        }
        y->left = x;
        x->parent = y;
    }

    // Code for right rotate
    void RR(Node* x) {
        Node* y = x->left;
        x->left = y->right;
        if (y->right != NULL_NODE) {
            y->right->parent = x;
        }

        y->parent = x->parent;
        if (x->parent == nullptr) {
            root = y;
        } else if (x == x->parent->right) {
            x->parent->right = y;
        } else {
            x->parent->left = y;
        }
        y->right = x;
        x->parent = y;
    }

    // Fix Up Insertion
    void fixInsert(Node* k) {
        while (k->parent->color == 1) {
            if (k->parent == k->parent->parent->right) {
                Node* u = k->parent->parent->left;
                if (u->color == 1) {
                    u->color = 0;
                    k->parent->color = 0;
                    k->parent->parent->color = 1;
                    k = k->parent->parent;
                } else {
                    if (k == k->parent->left) {
                        k = k->parent;
                        RR(k);
                    }
                    k->parent->color = 0;
                    k->parent->parent->color = 1;
                    LR(k->parent->parent);
                }
            } else {
                Node* u = k->parent->parent->right;
                if (u->color == 1) {
                    u->color = 0;
                    k->parent->color = 0;
                    k->parent->parent->color = 1;
                    k = k->parent->parent;
                } else {
                    if (k == k->parent->right) {
                        k = k->parent;
                        LR(k);
                    }
                    k->parent->color = 0;
                    k->parent->parent->color = 1;
                    RR(k->parent->parent);
                }
            }
            if (k == root) {
                break;
            }
        }
        root->color = 0;
    }

    // Function to fix issues after deletion
    void fixDelete(Node* x) {
        while (x != root && x->color == 0) {
            if (x == x->parent->left) {
                Node* s = x->parent->right;
                if (s->color == 1) {
                    s->color = 0;
                    x->parent->color = 1;
                    LR(x->parent);
                    s = x->parent->right;
                }

                if (s->left->color == 0 && s->right->color == 0) {
                    s->color = 1;
                    x = x->parent;
                } else {
                    if (s->right->color == 0) {
                        s->left->color = 0;
                        s->color = 1;
                        RR(s);
                        s = x->parent->right;
                    }

                    s->color = x->parent->color;
                    x->parent->color = 0;
                    s->right->color = 0;
                    LR(x->parent);
                    x = root;
                }
            } else {
                Node* s = x->parent->left;
                if (s->color == 1) {
                    s->color = 0;
                    x->parent->color = 1;
                    RR(x->parent);
                    s = x->parent->left;
                }

                if (s->right->color == 0 && s->left->color == 0) {
                    s->color = 1;
                    x = x->parent;
                } else {
                    if (s->left->color == 0) {
                        s->right->color = 0;
                        s->color = 1;
                        LR(s);
                        s = x->parent->left;
                    }

                    s->color = x->parent->color;
                    x->parent->color = 0;
                    s->left->color = 0;
                    RR(x->parent);
                    x = root;
                }
            }
        }
        x->color = 0;
    }

    // Function to transplant nodes
    void rbTransplant(Node* u, Node* v) {
        if (u->parent == nullptr) {
            root = v;
        } else if (u == u->parent->left) {
            u->parent->left = v;
        } else {
            u->parent->right = v;
        }
        v->parent = u->parent;
    }

    // Function to handle deletion
    void deleteNodeHelper(Node* node, int key) {
        Node* z = NULL_NODE;
        Node* temp = node;
        while (temp != NULL_NODE) {
            if (temp->val == key) {
                z = temp;
            }

            if (temp->val <= key) {
                temp = temp->right;
            } else {
                temp = temp->left;
            }
        }

        if (z == NULL_NODE) {
            std::cout << "Value not present in Tree !!" << std::endl;
            return;
        }

        Node* y = z;
        int y_original_color = y->color;
        Node* x;
        if (z->left == NULL_NODE) {
            x = z->right;
            rbTransplant(z, z->right);
        } else if (z->right == NULL_NODE) {
            x = z->left;
            rbTransplant(z, z->left);
        } else {
            y = minimum(z->right);
            y_original_color = y->color;
            x = y->right;
            if (y->parent == z) {
                x->parent = y;
            } else {
                rbTransplant(y, y->right);
                y->right = z->right;
                y->right->parent = y;
            }

            rbTransplant(z, y);
            y->left = z->left;
            y->left->parent = y;
            y->color = z->color;
        }
        delete z; // Free the deleted node.
        if (y_original_color == 0) {
            fixDelete(x);
        }
    }

    // Deletion of node
    void deleteNode(int val) {
        deleteNodeHelper(root, val);
    }

    // Function to print
    void printCall(Node* node, std::string indent, bool last) {
        if (node != NULL_NODE) {
            std::cout << indent;
            if (last) {
                std::cout << "R----";
                indent += "     ";
            } else {
                std::cout << "L----";
                indent += "|    ";
            }

            std::string s_color = (node->color == 1) ? "RED" : "BLACK";
            std::cout << node->val << "(" << s_color << ")" << std::endl;
            printCall(node->left, indent, false);
            printCall(node->right, indent, true);
        }
    }

    // Function to call print
    void printTree() {
        printCall(root, "", true);
    }
};

int main() {
    RBTree bst;

    std::cout << "State of the tree after inserting the 30 keys:" << std::endl;
    for (int x = 1; x < 30; ++x) {
        bst.insertNode(x);
    }
    bst.printTree();

    std::cout << "\nState of the tree after deleting the 15 keys:" << std::endl;
    for (int x = 1; x < 15; ++x) {
        bst.deleteNode(x);
    }
    bst.printTree();

    //Remember to free memory to prevent memory leaks when the program ends.  This example is missing that.  Implementing this would be a bit involved, especially for the delete operation.
    return 0;
}
