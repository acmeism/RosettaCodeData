int main() {
  NG_4 a2(7,0,0,22);
  r2cf n2(22,7);
  for(NG n(&a2, &n2); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
