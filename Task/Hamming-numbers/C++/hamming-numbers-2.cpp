int main() {
  int count = 1;
  for (unsigned int i : Ham({2,3,5})) {
    if (count <= 62) std::cout << i << ' ';
    if (count++ == 1691) {
      std::cout << "\nThe one thousand six hundred and ninety first Hamming Number is " << i << std::endl;
      break;
    }
  }
  return 0;
}
