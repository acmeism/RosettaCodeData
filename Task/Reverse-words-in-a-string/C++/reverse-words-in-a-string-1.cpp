#include <algorithm>
#include <functional>
#include <string>
#include <iostream>
#include <vector>

//code for a C++11 compliant compiler
template <class BidirectionalIterator, class T>
void block_reverse_cpp11(BidirectionalIterator first, BidirectionalIterator last, T const& separator) {
   std::reverse(first, last);
   auto block_last = first;
   do {
      using std::placeholders::_1;
      auto block_first = std::find_if_not(block_last, last,
         std::bind(std::equal_to<T>(),_1, separator));
      block_last = std::find(block_first, last, separator);
      std::reverse(block_first, block_last);
   } while(block_last != last);
}

//code for a C++03 compliant compiler
template <class BidirectionalIterator, class T>
void block_reverse_cpp03(BidirectionalIterator first, BidirectionalIterator last, T const& separator) {
   std::reverse(first, last);
   BidirectionalIterator block_last = first;
   do {
      BidirectionalIterator block_first = std::find_if(block_last, last,
         std::bind2nd(std::not_equal_to<T>(), separator));
      block_last = std::find(block_first, last, separator);
      std::reverse(block_first, block_last);
   } while(block_last != last);
}

int main() {
   std::string str1[] =
    {
        "---------- Ice and Fire ------------",
        "",
        "fire, in end will world the say Some",
        "ice. in say Some",
        "desire of tasted I've what From",
        "fire. favor who those with hold I",
        "",
        "... elided paragraph last ...",
        "",
        "Frost Robert -----------------------"
    };

   std::for_each(begin(str1), end(str1), [](std::string& s){
      block_reverse_cpp11(begin(s), end(s), ' ');
      std::cout << s << std::endl;
   });

   std::for_each(begin(str1), end(str1), [](std::string& s){
      block_reverse_cpp03(begin(s), end(s), ' ');
      std::cout << s << std::endl;
   });

   return 0;
}
