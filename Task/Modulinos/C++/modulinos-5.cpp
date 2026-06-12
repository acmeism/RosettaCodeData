#include "scriptedmain.h"
#include <iostream>

using namespace std;

extern int meaning_of_life();

int main() {
	cout << "Test: The meaning of life is " << meaning_of_life() << endl;
	return 0;
}
