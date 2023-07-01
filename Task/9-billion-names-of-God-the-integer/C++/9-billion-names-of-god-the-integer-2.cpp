#include <iostream>
#include <iomanip>
int main(){
  N=25;
  for (int n=1; n<N/2; n++){
    G_hyp(n);
    for (int g=0; g<N-3; g++) std::cout << std::setw(4) << hyp[g];
    std::cout << std::endl;
  }
}
