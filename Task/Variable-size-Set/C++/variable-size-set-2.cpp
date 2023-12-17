#include <iostream>
#include <climits>
#include <cfloat>

int main() {
	std::cout << "The ranges of C++'s primitive data types are:" << std::endl << std::endl;

	std::cout << "a  char ranges from          : " << CHAR_MIN << " to " << CHAR_MAX << std::endl;
	std::cout << "a  short char ranges from    : " << SCHAR_MIN << " to " << SCHAR_MAX << std::endl;
	std::cout << "an unsigned char ranges from : " << 0 << " to " << UCHAR_MAX << std::endl << std::endl;

	std::cout << "a  short int ranges from          : " << SHRT_MIN << " to " << SHRT_MAX << std::endl;
	std::cout << "an unsigned short int ranges from : " << 0 << " to " << USHRT_MAX << std::endl << std::endl;

	std::cout << "an int ranges from          : " << INT_MIN << " to " << INT_MAX << std::endl;
	std::cout << "an unsigned int ranges from : " << 0 << " to " << UINT_MAX << std::endl << std::endl;

	std::cout << "a  long int ranges from               : " << LONG_MIN << " to " << LONG_MAX << std::endl;
	std::cout << "an unsigned long int ranges from      : " << 0 << " to " << ULONG_MAX << std::endl;
	std::cout << "a  long long int ranges from          : " << LLONG_MIN << " to " << LLONG_MAX << std::endl;
	std::cout << "an unsigned long long int ranges from : " << 0 << " to " << ULLONG_MAX <<std::endl << std::endl;

	std::cout << "a  float ranges from : " << -FLT_MAX << " to " << +FLT_MAX << std::endl << std::endl;

	std::cout << "a  double ranges from : " << -DBL_MAX << " to " << +DBL_MAX << std::endl;
}
