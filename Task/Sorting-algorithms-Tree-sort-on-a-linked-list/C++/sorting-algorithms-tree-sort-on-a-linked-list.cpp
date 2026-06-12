#include <iostream>
#include <memory>
#include <optional>
#include <vector>

template <class T>
class Binary_Tree {
public:
	void insert(const T& item) {
        if ( ! node.has_value() ) {
            node = std::make_optional(item);
            left = std::make_unique<Binary_Tree<T>>();
            right = std::make_unique<Binary_Tree<T>>();
        } else if ( item < node.value() ) {
            left->insert(item);
        } else {
            right->insert(item);
        }
    }

	void inorder() const {
		if ( node.has_value() ) {
			left->inorder();
			std::cout << node.value() << " ";
			right->inorder();
		}
	}

private:
	std::optional<T> node;
	std::unique_ptr<Binary_Tree> left;
	std::unique_ptr<Binary_Tree> right;
};

template <typename T>
void tree_sort(std::vector<T> vec) {
	for ( const T& t : vec ) {
		std::cout << t << " ";
	}
	std::cout << "=> ";

	Binary_Tree<T> tree;
	for ( const T& t : vec ) {
		tree.insert(t);
	}
	tree.inorder();
	std::cout << std::endl;
}

int main() {
	const std::vector<int> vector_int = { 5, 3, 7, 9, 1 };
	const std::vector<char> vector_char = { 'd', 'c', 'e', 'b', 'a' };

	tree_sort(vector_int);
	tree_sort(vector_char);
}
