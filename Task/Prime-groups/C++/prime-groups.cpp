#include <cstdint>
#include <iostream>
#include <string>
#include <vector>

bool is_prime(const uint32_t& number) {
	if ( number < 2 || number % 2 == 0 ) {
		return number == 2;
	}
	uint32_t k = 3;
	while ( k * k <= number ) {
		if ( number % k == 0 ) {
			return false;
		}
		k += 2;
	}
	return true;
}

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]" << std::endl;
}

template <typename T>
void combinationsRecursive(const uint32_t& index, const uint32_t& r,
		             	   std::vector<T>& data, std::vector<std::vector<T>>& result, std::vector<T>& source) {
    if ( data.size() == r ) {
        result.emplace_back(data);
        return;
    }

    for ( uint32_t i = index; i < source.size(); ++i ) {
        data.emplace_back(source[i]);
        combinationsRecursive(i + 1, r, data, result, source);
        data.pop_back();
    }
}

template <typename T>
std::vector<std::vector<T>> combinations(std::vector<T>& source, const uint32_t& r) {
    std::vector<std::vector<T>> result;
    std::vector<T> data;
    combinationsRecursive(0, r, data, result, source);
    return result;
}

int main() {
	std::vector<std::string> words = { "riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja" };

	std::vector<std::string> result;

	std::cout << "Groups of 3 letters: ";
	for ( const std::string& word : words ) {
		std::string group3 = "Not found";
		std::vector<char> chars(word.begin(), word.end());

		for ( std::vector<char> combo : combinations(chars, 3) ) {
			if ( is_prime(std::abs(combo[0] - combo[1])) &&
				is_prime(std::abs(combo[0] - combo[2])) &&
				is_prime(std::abs(combo[1] - combo[2])) ) {
				std::string temp(combo.begin(), combo.end());
				group3 = temp;
				break;
			}
		}

		result.emplace_back(group3);
	}

	print_vector(result);
	result.clear();

	std::cout << "Groups of 2 letters: ";
	for ( const std::string& word : words ) {
		std::string group2 = "Not found";
		std::vector<char> chars(word.begin(), word.end());

	    for ( const std::vector<char>& pair : combinations(chars, 2) ) {
	    	if ( is_prime(std::abs(pair[0] - pair[1])) ) {
	    		std::string temp(pair.begin(), pair.end());
	    		group2 = temp;
	    		break;
	    	}
	    }

	    result.emplace_back(group2);
	}

	print_vector(result);
}
