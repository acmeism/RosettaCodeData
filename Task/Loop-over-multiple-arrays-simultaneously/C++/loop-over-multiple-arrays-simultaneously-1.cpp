#include <iostream>
#include <vector>

int main(int argc, char* argv[])
{
   std::vector<char> ls(3); ls[0] = 'a'; ls[1] = 'b'; ls[2] = 'c';
   std::vector<char> us(3); us[0] = 'A'; us[1] = 'B'; us[2] = 'C';
   std::vector<int> ns(3);  ns[0] = 1;   ns[1] = 2;   ns[2] = 3;

   std::vector<char>::const_iterator lIt = ls.begin();
   std::vector<char>::const_iterator uIt = us.begin();
   std::vector<int>::const_iterator nIt = ns.begin();
   for(; lIt != ls.end() && uIt != us.end() && nIt != ns.end();
       ++lIt, ++uIt, ++nIt)
   {
      std::cout << *lIt << *uIt << *nIt << "\n";
   }
}
