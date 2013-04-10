/* Interface for all matrixNG classes
   Nigel Galloway, February 10th., 2013.
*/
class matrixNG {
  private:
  virtual void consumeTerm(){}
  virtual void consumeTerm(int n){}
  virtual const bool needTerm(){}
  protected: int cfn = 0, thisTerm;
             bool haveTerm = false;
  friend class NG;
};
/* Implement the babyNG matrix
   Nigel Galloway, February 10th., 2013.
*/
class NG_4 : public matrixNG {
  private: int a1, a, b1, b, t;
  const bool needTerm() {
    if (b1==0 and b==0) return false;
    if (b1==0 or b==0) return true; else thisTerm = a/b;
    if (thisTerm==(int)(a1/b1)){
      t=a; a=b; b=t-b*thisTerm; t=a1; a1=b1; b1=t-b1*thisTerm;
      haveTerm=true; return false;
    }
    return true;
  }
  void consumeTerm(){a=a1; b=b1;}
  void consumeTerm(int n){t=a; a=a1; a1=t+a1*n; t=b; b=b1; b1=t+b1*n;}
  public:
  NG_4(int a1, int a, int b1, int b): a1(a1), a(a), b1(b1), b(b){}
};
/* Implement a Continued Fraction which returns the result of an arithmetic operation on
   1 or more Continued Fractions (Currently 1 or 2).
   Nigel Galloway, February 10th., 2013.
*/
class NG : public ContinuedFraction {
  private:
   matrixNG* ng;
   ContinuedFraction* n[2];
  public:
  NG(NG_4* ng, ContinuedFraction* n1): ng(ng){n[0] = n1;}
  NG(NG_8* ng, ContinuedFraction* n1, ContinuedFraction* n2): ng(ng){n[0] = n1; n[1] = n2;}
  const int nextTerm() {ng->haveTerm = false; return ng->thisTerm;}
  const bool moreTerms(){
    while(ng->needTerm()) if(n[ng->cfn]->moreTerms()) ng->consumeTerm(n[ng->cfn]->nextTerm()); else ng->consumeTerm();
    return ng->haveTerm;
  }
};
