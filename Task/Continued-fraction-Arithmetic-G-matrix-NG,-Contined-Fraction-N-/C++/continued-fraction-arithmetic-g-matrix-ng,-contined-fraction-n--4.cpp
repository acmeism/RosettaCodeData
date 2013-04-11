int main() {
  NG_4 a3(2,1,0,2);
  r2cf n3(22,7);
  for(NG n(&a3, &n3); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
