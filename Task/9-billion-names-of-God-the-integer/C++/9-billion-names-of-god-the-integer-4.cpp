#include <iostream>
int main(){
  for (int n=1; n<N/2; n++) G_hyp(n);
  std::cout << "G(23)     = " << hyp[21] << std::endl;
  std::cout << "G(123)    = " << hyp[121] << std::endl;
  std::cout << "G(1234)   = " << hyp[1232] << std::endl;
  std::cout << "G(12345)  = " << hyp[12343] << std::endl;
  mpz_class r{3};
  for (int i = 0; i<N-3; i++) r += hyp[i];
  std::cout << "G(123456) = " << r << std::endl;
}
