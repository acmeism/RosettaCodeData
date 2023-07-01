#include <iostream>
#include <istream>
#include <ostream>
#include <fstream>
#include <cstdlib>
#include <string>

// the rot13 function
std::string rot13(std::string s)
{
  static std::string const
    lcalph = "abcdefghijklmnopqrstuvwxyz",
    ucalph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  std::string result;
  std::string::size_type pos;

  result.reserve(s.length());

  for (std::string::iterator it = s.begin(); it != s.end(); ++it)
  {
    if ( (pos = lcalph.find(*it)) != std::string::npos )
      result.push_back(lcalph[(pos+13) % 26]);
    else if ( (pos = ucalph.find(*it)) != std::string::npos )
      result.push_back(ucalph[(pos+13) % 26]);
    else
      result.push_back(*it);
  }

  return result;
}

// function to output the rot13 of a file on std::cout
// returns false if an error occurred processing the file, true otherwise
// on entry, the argument is must be open for reading
int rot13_stream(std::istream& is)
{
  std::string line;
  while (std::getline(is, line))
  {
    if (!(std::cout << rot13(line) << "\n"))
      return false;
  }
  return is.eof();
}

// the main program
int main(int argc, char* argv[])
{
  if (argc == 1) // no arguments given
    return rot13_stream(std::cin)? EXIT_SUCCESS : EXIT_FAILURE;

  std::ifstream file;
  for (int i = 1; i < argc; ++i)
  {
    file.open(argv[i], std::ios::in);
    if (!file)
    {
      std::cerr << argv[0] << ": could not open for reading: " << argv[i] << "\n";
      return EXIT_FAILURE;
    }
    if (!rot13_stream(file))
    {
      if (file.eof())
        // no error occurred for file, so the error must have been in output
        std::cerr << argv[0] << ": error writing to stdout\n";
      else
        std::cerr << argv[0] << ": error reading from " << argv[i] << "\n";
      return EXIT_FAILURE;
    }
    file.clear();
    file.close();
    if (!file)
      std::cerr << argv[0] << ": warning: closing failed for " << argv[i] << "\n";
  }
  return EXIT_SUCCESS;
}
