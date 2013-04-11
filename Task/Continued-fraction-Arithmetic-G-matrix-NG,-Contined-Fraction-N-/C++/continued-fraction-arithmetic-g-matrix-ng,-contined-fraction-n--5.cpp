int main() {
  NG_4 a4(1,0,0,4);
  r2cf n4(22,7);
  for(NG n(&a4, &n4); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
