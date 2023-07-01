#include <string>
#include <fstream>

using namespace std;

void truncateFile(string filename, int max_size) {
  std::ifstream input( filename, std::ios::binary );
  char buffer;
  string outfile = filename + ".trunc";
  ofstream appendFile(outfile, ios_base::out);
  for(int i=0; i<max_size; i++) {
    input.read( &buffer, sizeof(buffer) );
    appendFile.write(&buffer,1);
  }
  appendFile.close();                                                                                                                                                                }

int main () {
  truncateFile("test.txt", 5);
  return 0;
}
