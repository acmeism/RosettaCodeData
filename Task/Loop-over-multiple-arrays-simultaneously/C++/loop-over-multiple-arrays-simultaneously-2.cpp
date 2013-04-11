#include <iostream>

int main(int argc, char* argv[])
{
   char ls[] = {'a', 'b', 'c'};
   char us[] = {'A', 'B', 'C'};
   int ns[] = {1, 2, 3};

   for(size_t li = 0, ui = 0, ni = 0;
       li < sizeof(ls) && ui < sizeof(us) && ni < sizeof(ns) / sizeof(int);
       ++li, ++ui, ++ni)
   {
      std::cout << ls[li] << us[ui] << ns[ni] << "\n";
   }
}
