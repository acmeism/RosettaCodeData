int main() {
  NG_8 c(0,1,-1,0,0,0,0,1);
  r2cf c1(13,11);
  r2cf c2(22,7);
  for(NG n(&c, &c1, &c2); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf cf(-151,77); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
