#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <unordered_set>
#include <vector>

struct Item {
	std::string word;
	int32_t number;
	int32_t digital_root;
};

void display(const std::vector<Item>& items) {
	std::cout << "  Word      Decimal value   Digital root" << std::endl;
	std::cout << "----------------------------------------" << std::endl;
	for ( const Item& item : items ) {
		std::cout << std::setw(7) << item.word << std::setw(15) << item.number
				  << std::setw(12) << item.digital_root << std::endl;
	}
	std::cout << "\n" << "Total count: " << items.size() << "\n" << std::endl;
}

int32_t digital_root(int32_t number) {
	int32_t result = 0;
	while ( number > 0 ) {
		result += number % 10;
		number /= 10;
	}
	return ( result <= 9 ) ? result : digital_root(result);
}

bool contains_only(const std::string& word, const std::unordered_set<char>& acceptable) {
    return std::all_of(word.begin(), word.end(),
    	[acceptable](char ch) { return acceptable.find(ch) != acceptable.end(); });
}

int main() {
	const std::unordered_set<char> hex_digits{ 'a', 'b', 'c', 'd', 'e', 'f' };
	std::vector<Item> items;

	std::fstream file_stream;
	file_stream.open("unixdict.txt");
	std::string word;
	while ( file_stream >> word ) {
		if ( word.length() >= 4 && contains_only(word, hex_digits)) {
			const int32_t value = std::stoi(word, 0, 16);
			int32_t root = digital_root(value);
			items.push_back(Item(word, value, root));
		}
	}

	auto compare = [](Item a, Item b) {
		return ( a.digital_root == b.digital_root ) ? a.word < b.word : a.digital_root < b.digital_root;
	};
	std::sort(items.begin(), items.end(), compare);
	display(items);

	std::vector<Item> filtered_items;
	for ( const Item& item : items ) {
		if ( std::unordered_set<char>(item.word.begin(), item.word.end()).size() >= 4 ) {
			filtered_items.push_back(item);
		}
	}

	auto comp = [](Item a, Item b) { return a.number > b.number; };
	std::sort(filtered_items.begin(), filtered_items.end(), comp);
	display(filtered_items);
}
