#include <iostream>   // cout for printing
#include <algorithm>  // for_each defined here
#include <vector>     // stl vector class
#include <functional> // bind and ptr_fun

// create a binary function (print any two arguments together)
template<class type1,class type2>
void print_juxtaposed(type1 x, type2 y) {
  std::cout << x << y;
}

int main() {
  // create the array
  std::vector<int> ary;
  ary.push_back(1);
  ary.push_back(2);
  ary.push_back(3);
  ary.push_back(4);
  ary.push_back(5);
  // stl for_each, using binder and adaptable unary function
  std::for_each(ary.begin(),ary.end(),std::bind2nd(std::ptr_fun(print_juxtaposed<int,std::string>),"x "));
  return 0;
}
//prints 1x 2x 3x 4x 5x
