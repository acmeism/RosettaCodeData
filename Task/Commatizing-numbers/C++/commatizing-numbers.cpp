#include <algorithm>
#include <cstdint>
#include <iostream>
#include <string>

bool contains(const std::string& haystack, const char needle) {
	return haystack.find(needle) != std::string::npos;
}

void commatize(std::string text, const int32_t& start_index = 0,
			   const int32_t& step = 3, const std::string& separator = ",") {
	std::cout << "Before: " << text << std::endl;
	const int32_t size = text.size();

	for ( int32_t i = start_index; i < size; ++i ) {
		if ( contains("123456789", text[i]) ) {
			for ( int32_t j = i + 1; j <= size; ++j ) {
				if ( j > size || ! contains("0123456789", text[j]) ) {
					for ( int32_t k = j - 1 - step; k >= i; k -= step ) {
						text.insert(k + 1, separator);
					}
					break;
				}
			}
			break;
		}
	}

	std::cout << " After: " << text << std::endl << std::endl;
}

int main() {
	commatize("pi=3.14159265358979323846264338327950288419716939937510582097494459231", 6, 5, " ");
	commatize("The author has two Z$100000000000000 Zimbabwe notes (100 trillion).");
	commatize("\"-in Aus$+1411.8millions\"");
	commatize("===US$0017440 millions=== (in 2000 dollars)");
	commatize("123.e8000 is pretty big.");
	commatize("The land area of the earth is 57268900(29% of the surface) square miles.");
	commatize("Ain't no numbers in this here words, nohow, no way, Jose.");
	commatize("James was never known as 0000000007");
	commatize("Arthur Eddington wrote: I believe there are "
	"15747724136275002577605653961181555468044717914527116709366231425076185631031296"
	" protons in the universe.");
	commatize("   $-140000±100 millions.");
	commatize("6/9/1946 was a good year for some.");
}
