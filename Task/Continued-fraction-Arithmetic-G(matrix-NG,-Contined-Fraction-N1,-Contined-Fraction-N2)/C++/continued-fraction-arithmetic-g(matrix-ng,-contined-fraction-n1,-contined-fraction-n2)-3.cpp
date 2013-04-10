int main() {
  NG_8 b(1,0,0,0,0,0,0,1);
  r2cf b1(13,11);
  r2cf b2(22,7);
  for(NG n(&b, &b1, &b2); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(NG n(&a, &b2, &b1); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf cf(286,77); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
