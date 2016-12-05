#include <iostream>
#include <fstream>

int main()
{
	std::cout << std::ifstream("input.txt", std::ios::binary | std::ios::ate).tellg() << "\n"
		  << std::ifstream("/input.txt", std::ios::binary | std::ios::ate).tellg() << "\n";
}
