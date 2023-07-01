#include <stdio.h>
#define INT(body) ({ int lambda(){ body; }; lambda; })
main(){
  int a(int k, int xl(), int x2(), int x3(), int x4(), int x5()){
    int b(){
      return a(--k, b, xl, x2, x3, x4);
    }
    return k<=0 ? x4() + x5() : b();
  }
  printf(" %d\n",a(10, INT(return 1), INT(return -1), INT(return -1), INT(return 1), INT(return 0)));
}
