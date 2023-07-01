#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

int main()
{
  std::ifstream infile("thefile.txt");
  std::string line;
  while (std::getline(infile, line) )
     {
        std::istringstream iss(line);
        int a, b;
        if (!(iss >> a >> b)) { break; } // if no error a and b get values from file

        std::cout << "a:\t" << a <<"\n";
        std::cout << "b:\t" << b <<"\n";
     }
      std::cout << "finished" << std::endl;
}
