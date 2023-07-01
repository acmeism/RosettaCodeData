#include <functional>
#include <iostream>
#include <random>

class BinarySearchTree {
private:
    struct Node {
        int key;
        Node *left, *right;

        Node(int k) : key(k), left(nullptr), right(nullptr) {
            //empty
        }
    } *root;

public:
    BinarySearchTree() : root(nullptr) {
        // empty
    }

    bool insert(int key) {
        if (root == nullptr) {
            root = new Node(key);
        } else {
            auto n = root;
            Node *parent;
            while (true) {
                if (n->key == key) {
                    return false;
                }

                parent = n;

                bool goLeft = key < n->key;
                n = goLeft ? n->left : n->right;

                if (n == nullptr) {
                    if (goLeft) {
                        parent->left = new Node(key);
                    } else {
                        parent->right = new Node(key);
                    }
                    break;
                }
            }
        }
        return true;
    }

    friend std::ostream &operator<<(std::ostream &, const BinarySearchTree &);
};

template<typename T>
void display(std::ostream &os, const T *n) {
    if (n != nullptr) {
        os << "Node(";

        display(os, n->left);

        os << ',' << n->key << ',';

        display(os, n->right);

        os << ")";
    } else {
        os << '-';
    }
}

std::ostream &operator<<(std::ostream &os, const BinarySearchTree &bst) {
    display(os, bst.root);
    return os;
}

int main() {
    std::default_random_engine generator;
    std::uniform_int_distribution<int> distribution(0, 200);
    auto rng = std::bind(distribution, generator);

    BinarySearchTree tree;

    tree.insert(100);
    for (size_t i = 0; i < 20; i++) {
        tree.insert(rng());
    }
    std::cout << tree << '\n';

    return 0;
}
