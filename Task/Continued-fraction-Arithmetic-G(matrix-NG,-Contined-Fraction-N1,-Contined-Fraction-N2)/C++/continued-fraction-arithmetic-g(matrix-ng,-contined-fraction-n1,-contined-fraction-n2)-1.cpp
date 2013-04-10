/* Implement matrix NG
   Nigel Galloway, February 12., 2013
*/
class NG_8 : public matrixNG {
  private: int a12, a1, a2, a, b12, b1, b2, b, t;
           double ab, a1b1, a2b2, a12b12;
  const int chooseCFN(){return fabs(a1b1-ab) > fabs(a2b2-ab)? 0 : 1;}
  const bool needTerm() {
    if (b1==0 and b==0 and b2==0 and b12==0) return false;
    if (b==0){cfn = b2==0? 0:1; return true;} else ab = ((double)a)/b;
    if (b2==0){cfn = 1; return true;} else a2b2 = ((double)a2)/b2;
    if (b1==0){cfn = 0; return true;} else a1b1 = ((double)a1)/b1;
    if (b12==0){cfn = chooseCFN(); return true;} else a12b12 = ((double)a12)/b12;
    thisTerm = (int)ab;
    if (thisTerm==(int)a1b1 and thisTerm==(int)a2b2 and thisTerm==(int)a12b12){
      t=a; a=b; b=t-b*thisTerm; t=a1; a1=b1; b1=t-b1*thisTerm; t=a2; a2=b2; b2=t-b2*thisTerm; t=a12; a12=b12; b12=t-b12*thisTerm;
      haveTerm = true; return false;
    }
    cfn = chooseCFN();
    return true;
  }
  void consumeTerm(){if(cfn==0){a=a1; a2=a12; b=b1; b2=b12;} else{a=a2; a1=a12; b=b2; b1=b12;}}
  void consumeTerm(int n){
    if(cfn==0){t=a; a=a1; a1=t+a1*n; t=a2; a2=a12; a12=t+a12*n; t=b; b=b1; b1=t+b1*n; t=b2; b2=b12; b12=t+b12*n;}
    else{t=a; a=a2; a2=t+a2*n; t=a1; a1=a12; a12=t+a12*n; t=b; b=b2; b2=t+b2*n; t=b1; b1=b12; b12=t+b12*n;}
  }
  public:
  NG_8(int a12, int a1, int a2, int a, int b12, int b1, int b2, int b): a12(a12), a1(a1), a2(a2), a(a), b12(b12), b1(b1), b2(b2), b(b){
}};
