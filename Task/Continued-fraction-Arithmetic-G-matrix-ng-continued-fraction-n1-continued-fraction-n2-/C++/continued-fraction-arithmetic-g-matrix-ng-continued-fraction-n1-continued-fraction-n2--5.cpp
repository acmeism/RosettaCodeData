int main() {
  NG_8 d(0,1,0,0,0,0,1,0);
  r2cf d1(22*22,7*7);
  r2cf d2(22,7);
  for(NG n(&d, &d1, &d2); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
