// For a class N which implements Zeckendorf numbers:
// I define an increment operation ++()
// I define a comparison operation <=(other N)
// I define an addition operation +=(other N)
// I define a subtraction operation -=(other N)
// Nigel Galloway October 28th., 2012
#include <iostream>
enum class zd {N00,N01,N10,N11};
class N {
private:
  int dVal = 0, dLen;
  void _a(int i) {
    for (;; i++) {
      if (dLen < i) dLen = i;
      switch ((zd)((dVal >> (i*2)) & 3)) {
        case zd::N00: case zd::N01: return;
        case zd::N10: if (((dVal >> ((i+1)*2)) & 1) != 1) return;
                      dVal += (1 << (i*2+1)); return;
        case zd::N11: dVal &= ~(3 << (i*2)); _b((i+1)*2);
  }}}
  void _b(int pos) {
    if (pos == 0) {++*this; return;}
    if (((dVal >> pos) & 1) == 0) {
      dVal += 1 << pos;
      _a(pos/2);
      if (pos > 1) _a((pos/2)-1);
      } else {
      dVal &= ~(1 << pos);
      _b(pos + 1);
      _b(pos - ((pos > 1)? 2:1));
  }}
  void _c(int pos) {
    if (((dVal >> pos) & 1) == 1) {dVal &= ~(1 << pos); return;}
    _c(pos + 1);
    if (pos > 0) _b(pos - 1); else ++*this;
    return;
  }
public:
  N(char const* x = "0") {
    int i = 0, q = 1;
    for (; x[i] > 0; i++);
    for (dLen = --i/2; i >= 0; i--) {dVal+=(x[i]-48)*q; q*=2;
  }}
  const N& operator++() {dVal += 1; _a(0); return *this;}
  const N& operator+=(const N& other) {
    for (int GN = 0; GN < (other.dLen + 1) * 2; GN++) if ((other.dVal >> GN) & 1 == 1) _b(GN);
    return *this;
  }
  const N& operator-=(const N& other) {
    for (int GN = 0; GN < (other.dLen + 1) * 2; GN++) if ((other.dVal >> GN) & 1 == 1) _c(GN);
    for (;((dVal >> dLen*2) & 3) == 0 or dLen == 0; dLen--);
    return *this;
  }
  const N& operator*=(const N& other) {
    N Na = other, Nb = other, Nt, Nr;
    for (int i = 0; i <= (dLen + 1) * 2; i++) {
      if (((dVal >> i) & 1) > 0) Nr += Nb;
      Nt = Nb; Nb += Na; Na = Nt;
    }
    return *this = Nr;
  }
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
