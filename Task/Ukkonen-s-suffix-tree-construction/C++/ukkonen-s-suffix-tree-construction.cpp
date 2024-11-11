#include <algorithm>
#include <chrono>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <limits>
#include <map>
#include <set>
#include <string>
#include <vector>

class Node {
public:
	Node(const int32_t& start, const int32_t& end) : start(start), end(end) {}

	int32_t edge_length(const int32_t& text_index) {
		return std::min(end, text_index + 1) - start;
	}

	int32_t start, end, parent_link = 0, leaf_index = 0;
	std::map<char, int32_t> children{ };
};

class SuffixTree {
public:
	SuffixTree(const std::string& word) {
		text = word + '\u0004'; // Terminal character

		nodes.reserve(2 * text.length());
		root = newNode(UNDEFINED, UNDEFINED);
		active_node = root;

		for ( const char& character : text ) {
			extend_suffix_tree(character);
		}
	}

	std::map<std::string, std::set<int32_t>> get_longest_repeated_substrings() {
		std::vector<int32_t> indexes = doTraversal();
		std::string word = text.substr(0, text.length() - 1);
		std::map<std::string, std::set<int32_t>> result{ };

		if ( indexes.front() > 0 ) {
			for ( uint32_t i = 1; i < indexes.size(); ++i ) {
				std::string substring = word.substr(indexes[i], indexes.front());
				result[substring].insert(indexes[i]);
			}
		}

		return result;
	}

private:
	void extend_suffix_tree(const char& character) {
		need_parent_link = UNDEFINED;
		remainder++;

		 while ( remainder > 0 ) {
			if ( active_length == 0 ) {
				active_edge = text_index;
			}

			if ( ! nodes[active_node].children.contains(text[active_edge]) ) {
				const int32_t leaf = newNode(text_index, LEAF_NODE);
				nodes[active_node].children[text[active_edge]] = leaf;
				add_suffix_link(active_node);
			} else {
				const int32_t next = nodes[active_node].children[text[active_edge]];
				if ( walk_down(next) ) {
					continue;
				}

				if ( text[nodes[next].start + active_length] == character ) {
					active_length++;
					add_suffix_link(active_node);
					break;
				}

				const uint32_t split = newNode(nodes[next].start, nodes[next].start + active_length);
				nodes[active_node].children[text[active_edge]] = split;
				const int32_t leaf = newNode(text_index, LEAF_NODE);
				nodes[split].children[character] = leaf;
				nodes[next].start += active_length;
				nodes[split].children[text[nodes[next].start]] = next;
				add_suffix_link(split);
			}

			remainder--;

			if ( active_node == root && active_length > 0 ) {
				active_length--;
				active_edge = text_index - remainder + 1;
			} else {
				active_node = ( nodes[active_node].parent_link > 0 ) ? nodes[active_node].parent_link : root;
			}
		}

		text_index++;
	}

	bool walk_down(const int32_t& node) {
		if ( active_length >= nodes[node].edge_length(text_index) ) {
			active_edge += nodes[node].edge_length(text_index);
			active_length -= nodes[node].edge_length(text_index);
			active_node = node;

			return true;
		}

		return false;
	}

	void add_suffix_link(const int32_t& node) {
		if ( need_parent_link != UNDEFINED ) {
			nodes[need_parent_link].parent_link = node;
		}

		need_parent_link = node;
	}

	uint32_t newNode(const int32_t& start, const int32_t& end) {
		Node node(start, end);
		node.leaf_index = ( end == LEAF_NODE ) ? leaf_index_generator++ : UNDEFINED;
		nodes[current_node] = node;

		return current_node++;
	}

	std::vector<int32_t> doTraversal() {
		std::vector<int32_t> indexes{ };
		indexes.emplace_back(UNDEFINED);

		return traversal(indexes, nodes[root], 0);
	}

	std::vector<int32_t> traversal(std::vector<int32_t>& indexes, Node node, const int32_t& height) {
		if ( node.leaf_index == UNDEFINED ) {
			for ( std::pair<char, int32_t> entry : node.children ) {
				Node child = nodes[entry.second];
				traversal(indexes, child, height + child.edge_length(text_index));
			}
		} else if ( indexes.front() < height - node.edge_length(text_index) ) {
			indexes.clear();
			indexes.emplace_back(height - node.edge_length(text_index));
			indexes.emplace_back(node.leaf_index);
		} else if ( indexes.front() == height - node.edge_length(text_index) ) {
			indexes.emplace_back(node.leaf_index);
		}

		return indexes;
	}

	std::vector<Node> nodes;
	std::string text;

    int32_t root;
	int32_t active_node, active_length = 0, active_edge = 0;
	int32_t text_index = 0, current_node = 0, need_parent_link = 0, remainder = 0, leaf_index_generator = 0;

	const int32_t UNDEFINED = -1;
	const int32_t LEAF_NODE = INT32_MAX;
};

int main() {
	std::vector<int32_t> limits = { 1'000, 10'000, 100'000 };

	for ( const int32_t& limit : limits ) {
		std::ifstream stream("../piDigits.txt");
		std::string contents( ( std::istreambuf_iterator<char>(stream) ),
                              ( std::istreambuf_iterator<char>() ) );
		std::string pi_digits = contents.substr(0, limit);

		auto begin = std::chrono::high_resolution_clock::now();
		SuffixTree tree(pi_digits);
		std::map<std::string, std::set<int32_t>> substrings = tree.get_longest_repeated_substrings();
		auto end = std::chrono::high_resolution_clock::now();
		auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>( end - begin );

		std::cout << "First " << limit << " digits of pi has longest repeated characters:" << std::endl;
		for ( std::pair<std::string, std::set<int32_t>> entry : substrings ) {
			std::cout << "    '" << entry.first << "' starting at index ";
			for ( int32_t index : entry.second ) {
				std::cout << index << " ";
			}
			std::cout << std::endl;
		}

		std::cout << "Time taken: " << elapsed << " milliseconds." << std::endl << std::endl;
	}

	std::cout << "The timings show that the implementation has approximately linear performance."
              << std::endl;
}
