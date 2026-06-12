#include <cmath>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

struct Fraction {
	uint32_t numer;
	uint32_t denom;
};

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]";
}

std::vector<std::string> convergents(double x, const uint32_t size) {
	std::vector<uint32_t> components{};
	double fraction_part = 1.0;
	for ( uint32_t i = 0; i < size && fraction_part >= 0.000'000'001; ++i ) {
		uint32_t int_part = static_cast<uint32_t>(x);
		fraction_part = x - int_part;
		components.emplace_back(int_part);
		x = 1.0 / fraction_part;
	}

	std::vector<std::string> result{};
	Fraction a(0, 1);
	Fraction b (1, 0);
	for ( const uint32_t& component : components ) {
		Fraction a_copy(a.numer, a.denom);
		a = Fraction(b.numer, b.denom);
		b = Fraction(a_copy.numer + component * b.numer, a_copy.denom + component * b.denom);
		result.emplace_back(std::to_string(b.numer) + "/" + std::to_string(b.denom));
	}
	return result;
}

int main() {
	struct Test {
		std::string description;
		double value;
	};

	const std::vector<Test> tests = { Test("415/93", static_cast<double>(415) / 93),
									  Test("649/200", static_cast<double>(649) / 200),
									  Test("Square root of 2", std::sqrt(2)),
									  Test("Square root of 5", std::sqrt(5)),
									  Test("Golden ratio", ( std::sqrt(5) + 1.0 ) / 2.0) };

	std::cout << "The continued fraction convergents for the following (maximum 8 terms) are:" << std::endl;
	for ( const Test& test : tests ) {
		std::cout << std::setw(20) << test.description << " => ";
		print_vector(convergents(test.value, 8));
		std::cout << std::endl;
	}
}
