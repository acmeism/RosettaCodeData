int main() {
  NG_8 a(0,1,1,0,0,0,0,1);
  r2cf n2(22,7);
  r2cf n1(1,2);
  for(NG n(&a, &n1, &n2); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;

  NG_4 a3(2,1,0,2);
  r2cf n3(22,7);
  for(NG n(&a3, &n3); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
