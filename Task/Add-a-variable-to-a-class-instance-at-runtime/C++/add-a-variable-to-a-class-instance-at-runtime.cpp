#include <cstdint>
#include <iostream>
#include <map>
#include <string>

class Demonstration {
public:
	Demonstration() {
		variables = { };
	}

	std::map<std::string, double> variables;
};

int main() {
	Demonstration demo;
	std::cout << "Create two variables at runtime:" << std::endl;
	for ( uint32_t i = 1; i <= 2; ++i ) {
		std::cout << "    Variable number " << i << ":" << std::endl;
		std::cout << "        Enter name: " << std::endl;
		std::string name;
		std::cin >> name;
		std::cout << "        Enter value: " << std::endl;
		double value;
		std::cin >> value;
		demo.variables[name] = value;
	}

	std::cout << std::endl;
	std::cout << "Two new runtime variables appear to have been created." << std::endl;
	for ( const auto &[key, value] : demo.variables ) {
		std::cout << "Variable " << key << " = " << value << std::endl;
	}
}
