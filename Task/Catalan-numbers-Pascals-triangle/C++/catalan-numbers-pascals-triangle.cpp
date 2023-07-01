// Generate Catalan Numbers
//
// Nigel Galloway: June 9th., 2012
//
#include <iostream>
int main() {
  const int N = 15;
  int t[N+2] = {0,1};
  for(int i = 1; i<=N; i++){
    for(int j = i; j>1; j--) t[j] = t[j] + t[j-1];
    t[i+1] = t[i];
    for(int j = i+1; j>1; j--) t[j] = t[j] + t[j-1];
    std::cout << t[i+1] - t[i] << " ";
  }
  return 0;
}
