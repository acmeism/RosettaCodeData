#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;

int main() {
  fs::path current_dir(".");
  // list all files containing an mp3 extension
  for (auto &file : fs::recursive_directory_iterator(current_dir)) {
    if (file.path().extension() == ".mp3")
      std::cout << file.path().filename().string() << std::endl;
  }
}
