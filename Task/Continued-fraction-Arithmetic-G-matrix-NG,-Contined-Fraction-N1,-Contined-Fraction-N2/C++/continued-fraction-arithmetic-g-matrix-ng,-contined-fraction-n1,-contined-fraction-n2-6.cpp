int main() {
  r2cf a1(2,7);
  r2cf a2(13,11);
  NG_8 na(0,1,1,0,0,0,0,1);
  NG A(&na, &a1, &a2); //[0;3,2] + [1;5,2]
  r2cf b1(2,7);
  r2cf b2(13,11);
  NG_8 nb(0,1,-1,0,0,0,0,1);
  NG B(&nb, &b1, &b2); //[0;3,2] - [1;5,2]
  NG_8 nc(1,0,0,0,0,0,0,1); //A*B
  for(NG n(&nc, &A, &B); n.moreTerms(); std::cout << n.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf cf(2,7); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf cf(13,11); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  for(r2cf cf(-7797,5929); cf.moreTerms(); std::cout << cf.nextTerm() << " ");
  std::cout << std::endl;
  return 0;
}
