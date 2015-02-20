#include <iostream>
#include <fstream>
#include <cstdlib>

int main()
{
  std::ifstream input("input.txt");
  if (!input.is_open())
  {
    std::cerr << "could not open input.txt for reading.\n";
    return EXIT_FAILURE;
  }

  std::ofstream output("output.txt");
  if (!output.is_open())
  {
    std::cerr << "could not open output.txt for writing.\n";
    return EXIT_FAILURE;
  }

  output << input.rdbuf();
  if (!output)
  {
    std::cerr << "error copying the data.\n";
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
