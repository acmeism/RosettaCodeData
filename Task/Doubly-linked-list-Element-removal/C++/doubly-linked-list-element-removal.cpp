#include <algorithm>
#include <iostream>
#include <list>
#include <string>

template <typename T>
void print_list(const std::list<T>& lst) {
	std::cout << "[ ";
	for ( const std::string& element : lst ) {
		std::cout << element << " ";
	}
	std::cout << "]" << std::endl;
}

int main() {
	std::list<std::string> linked_list;
	linked_list.emplace_back("dog");
	linked_list.emplace_back("cat");
	linked_list.emplace_back("bear");
	std::cout << "Initial linked list:    "; print_list(linked_list);
	std::erase(linked_list, "cat");
	std::cout << "After removal of \"cat\": "; print_list(linked_list);
	std::erase(linked_list, "dog");
	std::cout << "After removal of \"dog\": "; print_list(linked_list);
}
