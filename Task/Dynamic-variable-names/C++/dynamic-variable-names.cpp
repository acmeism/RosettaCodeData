#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>
#include <unordered_map>

int main() {
	std::unordered_map<std::string, int32_t> variables;

	std::string name;
	std::cout << "Enter your variable name: " << std::endl;
	std::cin >> name;

	int32_t value;
	std::cout << "Enter your variable value: " << std::endl;
	std::cin >> value;

	variables[name] = value;

	std::cout << "You have created a variable '" << name << "' with a value of " << value << ":" << std::endl;

	std::for_each(variables.begin(), variables.end(),
	    [](std::pair<std::string, int32_t> pair) {
		    std::cout << pair.first << " = " << pair.second << std::endl;
	    }
	);
}
