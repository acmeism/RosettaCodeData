int main() {
  NG_4 a1(2,1,0,2);
  r2cf n1(13,11);
  for(NG n(&a1, &n1); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
