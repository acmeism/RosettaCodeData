#include <iostream>

int main() {
   const int size = 100000;
   int hofstadters[size] = { 1, 1 };
   for (int i = 3 ; i < size; i++)
      hofstadters[ i - 1 ] = hofstadters[ i - 1 - hofstadters[ i - 1 - 1 ]] +
                             hofstadters[ i - 1 - hofstadters[ i - 2 - 1 ]];
   std::cout << "The first 10 numbers are: ";
   for (int i = 0; i < 10; i++)
      std::cout << hofstadters[ i ] << ' ';
   std::cout << std::endl << "The 1000'th term is " << hofstadters[ 999 ] << " !" << std::endl;
   int less_than_preceding = 0;
   for (int i = 0; i < size - 1; i++)
      if (hofstadters[ i + 1 ] < hofstadters[ i ])
	     less_than_preceding++;
   std::cout << "In array of size: " << size << ", ";
   std::cout << less_than_preceding << " times a number was preceded by a greater number!" << std::endl;
   return 0;
}
