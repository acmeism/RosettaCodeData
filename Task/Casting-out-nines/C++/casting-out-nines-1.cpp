// Casting Out Nines
//
// Nigel Galloway. June 24th., 2012
//
#include <iostream>
int main() {
	int Base = 10;
	const int N = 2;
	int c1 = 0;
	int c2 = 0;
	for (int k=1; k<pow((double)Base,N); k++){
		c1++;
		if (k%(Base-1) == (k*k)%(Base-1)){
			c2++;
			std::cout << k << " ";
		}
	}
	std::cout << "\nTrying " << c2 << " numbers instead of " << c1 << " numbers saves " << 100 - ((double)c2/c1)*100 << "%" <<std::endl;
	return 0;
}
