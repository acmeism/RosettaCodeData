int main() {
  int i = 0;
  NG_4 a6(1,1,0,2);
  SQRT2 n6;
  for(NG n(&a6, &n6); n.moreTerms() and i++ < 20; std::cout << n.nextTerm() << " ");
  std::cout << "..." << std::endl;
  for(r2cf cf(24142136, 20000000); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
