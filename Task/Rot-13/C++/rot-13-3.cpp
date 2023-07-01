#include <string>
#include <iostream>
#include <fstream>

char rot13(const char c){
	if (c >= 'a' && c <= 'z')
		return (c - 'a' + 13) % 26 + 'a';
	else if (c >= 'A' && c <= 'Z')
		return (c - 'A' + 13) % 26 + 'A';
	return c;
}

std::string &rot13(std::string &s){
	for (auto &c : s) //range based for is the only used C++11 feature
		c = rot13(c);
	return s;
}

void rot13(std::istream &in, std::ostream &out){
	std::string s;
	while (std::getline(in, s))
		out << rot13(s) << '\n';
}

int main(int argc, char *argv[]){
	if (argc == 1)
		rot13(std::cin, std::cout);
	for (int arg = 1; arg < argc; ++arg){
		std::ifstream f(argv[arg]);
		if (!f)
			return EXIT_FAILURE;
		rot13(f, std::cout);
	}
}
