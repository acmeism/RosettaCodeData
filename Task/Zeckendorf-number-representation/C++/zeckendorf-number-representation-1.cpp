// For a class N which implements Zeckendorf numbers:
// I define an increment operation ++()
// I define a comparison operation <=(other N)
// Nigel Galloway October 22nd., 2012
#include <iostream>
class N {
private:
  int dVal = 0, dLen;
public:
  N(char const* x = "0"){
    int i = 0, q = 1;
    for (; x[i] > 0; i++);
    for (dLen = --i/2; i >= 0; i--) {
      dVal+=(x[i]-48)*q;
      q*=2;
  }}
  const N& operator++() {
    for (int i = 0;;i++) {
      if (dLen < i) dLen = i;
      switch ((dVal >> (i*2)) & 3) {
        case 0: dVal += (1 << (i*2)); return *this;
        case 1: dVal += (1 << (i*2)); if (((dVal >> ((i+1)*2)) & 1) != 1) return *this;
        case 2: dVal &= ~(3 << (i*2));
  }}}
  const bool operator<=(const N& other) const {return dVal <= other.dVal;}
  friend std::ostream& operator<<(std::ostream&, const N&);
};
N operator "" N(char const* x) {return N(x);}
std::ostream &operator<<(std::ostream &os, const N &G) {
  const static std::string dig[] {"00","01","10"}, dig1[] {"","1","10"};
  if (G.dVal == 0) return os << "0";
  os << dig1[(G.dVal >> (G.dLen*2)) & 3];
  for (int i = G.dLen-1; i >= 0; i--) os << dig[(G.dVal >> (i*2)) & 3];
  return os;
}
