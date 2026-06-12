#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <stdexcept>
#include <vector>

class Lunar {
public:
	Lunar(const int64_t& n) {
		if ( n < 0 ) {
			throw std::invalid_argument("Argument must be a non-negative integer.");
		}
		text = std::to_string(n);
	}

	Lunar add(const Lunar& other) const {
		const uint32_t maxLength = std::max(text.length(), other.text.length());
		std::string a = std::string(maxLength - text.length(), '0') + text;
		std::string b = std::string(maxLength - other.text.length(), '0') + other.text;
		std::string sum = "";
		for ( uint32_t i = 0; i < a.length(); ++i ) {
			sum += std::string(1, std::max(a[i], b[i]));
		}
		return Lunar(std::stoll(sum));
	}

	Lunar multiply(const Lunar& other) const {
		Lunar result(0);
		std::string reversed = other.text;
		std::reverse(reversed.begin(), reversed.end());
		for ( uint32_t i = 0; i < reversed.length(); ++i ) {
			const char digit = reversed[i];
			std::string row = "";
			for ( uint32_t j = 0; j < text.length(); ++j ) {
				row += std::string(1, std::min(text[j], digit));
			}
			row += std::string(i, '0');
			result = result.add(Lunar(std::stoll(row)));
		}
		return result;
	}

	Lunar increment() const {
	    return Lunar(std::stoll(text) + 1);
	}

	bool operator<(const Lunar& other) const {
		return std::stoll(text) < std::stoll(other.text);
	}

	std::string to_string() const {
		return text;
	}

private:
	std::string text;
};

int main() {
	const std::vector<std::vector<int64_t>> tests = { { 976, 348 }, { 23, 321 }, { 232, 35 }, { 123, 32192, 415, 8 } };

	for ( const std::vector<int64_t>& test : tests ) {
		std::string add_expression = "";
		std::string multiply_expression = "";
		Lunar add_result(0);
		Lunar multiply_result(9);
		for ( uint32_t i = 0; i < test.size() - 1; ++i ) {
			add_expression += std::to_string(test[i]) + " 🌙 + ";
			multiply_expression += std::to_string(test[i]) + " 🌙 x ";
			add_result = add_result.add(Lunar(test[i]));
			multiply_result = multiply_result.multiply(Lunar(test[i]));
		}
		add_expression += std::to_string(test.back());
		multiply_expression += std::to_string(test.back());
		add_result = add_result.add(Lunar(test.back()));
		multiply_result = multiply_result.multiply(Lunar(test.back()));
		std::cout << add_expression << " = " << add_result.to_string() << std::endl;
		std::cout << multiply_expression << " = " << multiply_result.to_string() << std::endl << std::endl;
	}

	std::cout << "First 20 distinct lunar even numbers:" << std::endl;
	std::set<Lunar> evens;
	Lunar n(0);
	while ( evens.size() < 20 ) {
		evens.insert(n.multiply(Lunar(2)));
		n = n.increment();
	}
	for ( const Lunar& lunar : evens ) {
		std::cout << lunar.to_string() << " ";
	}
	std::cout << std::endl << std::endl;

	std::cout << "First 20 lunar square numbers:" << std::endl;
	for ( uint32_t i = 0; i < 20; ++i ) {
		std::cout << Lunar(i).multiply(Lunar(i)).to_string() << " ";
	}
	std::cout << std::endl << std::endl;

	std::cout << "First 20 lunar factorials:" << std::endl;
	Lunar factorial(1);
	for ( uint32_t i = 1; i <= 20; ++i ) {
		factorial = factorial.multiply(Lunar(i));
		std::cout << factorial.to_string() << " ";
	}
	std::cout << std::endl << std::endl;

	Lunar current(0);
	Lunar next(1);
	while ( current.multiply(current) < next.multiply(next) ) {
		current = next;
		next = next.increment();
	}
	std::cout << "First number whose lunar square is smaller than the previous: " << next.to_string() << std::endl;
}
