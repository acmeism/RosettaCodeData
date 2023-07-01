int main() {
  for(r2cf n(31,10); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(314,100); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(3142,1000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(31428,10000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(314285,100000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(3142857,1000000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(31428571,10000000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf n(314285714,100000000); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
