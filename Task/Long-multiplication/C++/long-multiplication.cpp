#include <cln/integer.h>//for mathematical operations on arbitrarily long integers
#include <cln/integer_io.h>//for input/output of long integers
#include <iostream>

int main( ) {
   cln::cl_I base = 2 , exponent = 64 ;//cln is a namespace
   cln::cl_I factor = cln::expt_pos( base , exponent ) ;
   cln::cl_I product = factor * factor ;
   std::cout << "The result of 2^64 * 2^64 is " << product << " !\n" ;
   return 0 ;
}
