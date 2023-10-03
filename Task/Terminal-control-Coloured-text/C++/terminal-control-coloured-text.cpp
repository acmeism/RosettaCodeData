#include <iostream>
int main() {
	std::cout << "\033[42m";
	std::cout << "\033[4;37m";
	std::cout << "Green background with underlined white text" << std::endl;
	std::cout << "\033[0m" << std::endl;

	std::cout << "\033[0;103m";
	std::cout << "\033[1;34m";
	std::cout << "Bright yellow background with bold blue text" << std::endl;
	std::cout << "\033[0m" << std::endl;

	std::cout << "\033[46m";
	std::cout << "\033[1;95m";
	std::cout << "Cyan background with bold bright magenta text" << std::endl;
	std::cout << "\033[0m" << std::endl;
}
