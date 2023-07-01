#include <iostream>
#include <fstream>
#include <string>
#include <iterator>

int main( )
{
    if (std::ifstream infile("sample.txt"))
    {
        // construct string from iterator range
        std::string fileData(std::istreambuf_iterator<char>(infile), std::istreambuf_iterator<char>());

        cout << "File has " << fileData.size() << "chars\n";

        // don't need to manually close the ifstream; it will release the file when it goes out of scope
        return 0;
   }
   else
   {
      std::cout << "file not found!\n";
      return 1;
   }
}
