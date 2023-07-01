int main() {
  int count = 1;
  for (unsigned int i : Ham({2,3,5,7})) {
    std::cout << i << ' ';
    if (count++ == 64) break;
  }
  std::cout << std::endl;
  return 0;
}
