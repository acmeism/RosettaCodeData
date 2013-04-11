#include <iostream>
#include <math.h>

using namespace std;

// does:  prints all members of vector
// input: c - ASCII char with the name of the vector
//        d - degree of vector
//        A - pointer to vector
void Print(char c, int d, double* A) {
	int i;

	for (i=0; i < d+1; i++)
			cout << c << "[" << i << "]= " << A[i] << endl;
	cout << "Degree of " << c << ": " << d << endl << endl;
}
