#include <iostream>
using std::cout;
using std::endl;

#include <boost/Array.hpp>
#include <algorithm>
#include <boost/foreach.hpp>

int main()
{
   boost::array<int, 3> A;
   A[0] = 5; // not bounds checked
   A[1] = 2;
   A.at(2) = 3; // this is bounds checked.

   cout << A[0] << endl; // not bounds checked

   for (int i =0; i < 3; ++i) {
       cout << A.at(i) << endl; // this is bounds checked
   }

   // use it as you would any STL ordered container.
   std::reverse(A.begin(),A.end());
   BOOST_FOREACH(int i, A){cout << i << endl;}
}
