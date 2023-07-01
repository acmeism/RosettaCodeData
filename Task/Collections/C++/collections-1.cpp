int a[5]; // array of 5 ints (since int is POD, the members are not initialized)
a[0] = 1; // indexes start at 0

int primes[10] = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 }; // arrays can be initialized on creation

#include <string>
std::string strings[4]; // std::string is no POD, therefore all array members are default-initialized
                        // (for std::string this means initialized with empty strings)
