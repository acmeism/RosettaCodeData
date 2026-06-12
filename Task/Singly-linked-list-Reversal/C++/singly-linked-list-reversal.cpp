#include <cstdint>
#include <iostream>
#include <memory>

template <typename T>
class Singly_Linked_List {
public:
	Singly_Linked_List() : head(nullptr) {}

	bool add(const T& new_value) {
		return add(head, new_value);
	}

	bool remove(const T& remove_value) {
		return remove(head, head, remove_value);
	}

	bool reverse() {
		std::unique_ptr<Node> previous = nullptr;
		std::unique_ptr<Node> current = std::move(head);
		std::unique_ptr<Node> next = nullptr;

		while ( current ) {
			next = std::move(current->next);
			current->next = std::move(previous);
			previous = std::move(current);
			current = std::move(next);
		}

		head = std::move(previous);
		return true;
	}

	void print() const {
		std::cout << "[";
		print(head);
		std::cout << "]" << std::endl;
	}

private:
	struct Node {
		explicit Node(const T& value) : value(value), next(nullptr) {}

		T value;
		std::unique_ptr<Node> next;
	};

	bool add(const std::unique_ptr<Node>& node, const T& new_value) {
		if ( ! head ) {
			head = std::unique_ptr<Node>(new Node(new_value));
			return true;
		}

		if ( ! node->next ) {
			node->next = std::unique_ptr<Node>(new Node(new_value));
			return true;
		}
		return add(node->next, new_value);
	}

	bool remove(const std::unique_ptr<Node>& parent, const std::unique_ptr<Node>& node, const T& remove_value) {
		if ( ! node ) {
			return false;
		}

		if ( node->value == remove_value ) {
			if ( node->next ) {
				if ( node == head ) {
					head = std::move(node->next);
				} else {
					parent->next = std::move(node->next);
				}
				return true;
			}

			if ( node == head ) {
				head.reset(nullptr);
			} else {
				parent->next.reset(nullptr);
			}
			return true;
		}

		return remove(node, node->next, remove_value);
	}

	void print(const std::unique_ptr<Node>& node) const {
		if ( node ) {
			std::cout << node->value << " ";
			print(node->next);
		}
	}

	std::unique_ptr<Node> head;
};

int main() {
	Singly_Linked_List<uint32_t> linked_list;

	for ( uint32_t i = 1; i <= 9; ++i ) {
		linked_list.add(i);
	}
	std::cout << "Linked list   : "; linked_list.print();

	linked_list.remove(1);
	std::cout << "After remove 1: "; linked_list.print();

	linked_list.remove(5);
	std::cout << "After remove 5: "; linked_list.print();

	linked_list.remove(9);
	std::cout << "After remove 9: "; linked_list.print();

	linked_list.remove(5);
	std::cout << "After remove 5: "; linked_list.print();

	linked_list.reverse();
	std::cout << "After reverse : "; linked_list.print();
}
