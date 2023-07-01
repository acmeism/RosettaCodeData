# include <algorithm>
# include <fstream>

int main() {
  std::ifstream ifile("input.txt");
  std::ofstream ofile("output.txt");
  std::copy(std::istreambuf_iterator<char>(ifile),
            std::istreambuf_iterator<char>(),
            std::ostreambuf_iterator<char>(ofile));
}
