#include <string_view>
#include <iostream>

constexpr std::string_view spaces{ " \t\n\v\f" };

constexpr std::string_view trim_start(std::string_view str) {
	if (auto beg = str.find_first_not_of(spaces); beg != str.npos) {
		return str.substr(beg);
	}

	return str.substr(str.size());
}

constexpr std::string_view trim_end(std::string_view str) {
	if (auto end = str.find_last_not_of(spaces); end != str.npos) {
		return str.substr(0, end + 1);
	}

	return str.substr(0, 0);
}

constexpr std::string_view trim(std::string_view str) {
	auto beg = str.find_first_not_of(spaces);
	if (beg == str.npos) {
		return str.substr(str.size());
	}
	auto end = str.find_last_not_of(spaces);

	return str.substr(beg, end - beg + 1);
}

int main() {
	using std::string_view;
	using std::cout;

	string_view test_phrase{ "    There are unwanted blanks here!    " };
	string_view left_trimmed = trim_start(test_phrase);
	string_view right_trimmed = trim_end(test_phrase);

	cout << "The test phrase is :\"" << test_phrase << "\"\n";
	cout << "Trimmed on the left side :\"" << left_trimmed << "\"\n";
	cout << "Trimmed on the right side :\"" << right_trimmed << "\"\n";

	string_view trimmed = trim(test_phrase);

	cout << "Trimmed on both sides :\"" << trimmed << "\"\n";
}
