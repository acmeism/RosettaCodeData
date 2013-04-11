int main() {
  NG_4 a5(0,1,1,0);
  SQRT2 n5;
  int i = 0;
  for(NG n(&a5, &n5); n.moreTerms() and i++ < 20; std::cout << n.nextTerm() << " ");
  std::cout << "..." << std::endl;
  for(r2cf cf(10000000, 14142136); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
