#include <iostream>

using namespace std;

int meaning_of_life() {
	return 42;
}

#ifdef SCRIPTEDMAIN

int main() {
	cout << "Main: The meaning of life is " << meaning_of_life() << endl;
	return 0;
}

#endif
