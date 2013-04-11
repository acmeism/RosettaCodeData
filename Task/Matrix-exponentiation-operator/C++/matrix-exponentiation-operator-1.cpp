#include <complex>
#include <cmath>
#include <iostream>
using namespace std;

template<int MSize = 3, class T = complex<double> >
class SqMx {
  typedef T Ax[MSize][MSize];
  typedef SqMx<MSize, T> Mx;

private:
  Ax a;
  SqMx() { }

public:
  SqMx(const Ax &_a) { // constructor with pre-defined array
    for (int r = 0; r < MSize; r++)
      for (int c = 0; c < MSize; c++)
        a[r][c] = _a[r][c];
  }

  static Mx identity() {
    Mx m;
    for (int r = 0; r < MSize; r++)
      for (int c = 0; c < MSize; c++)
        m.a[r][c] = (r == c ? 1 : 0);
    return m;
  }

  friend ostream &operator<<(ostream& os, const Mx &p)
  { // ugly print
    for (int i = 0; i < MSize; i++) {
      for (int j = 0; j < MSize; j++)
        os << p.a[i][j] << ",";
      os << endl;
    }
    return os;
  }

  Mx operator*(const Mx &b) {
    Mx d;
    for (int r = 0; r < MSize; r++)
      for (int c = 0; c < MSize; c++) {
        d.a[r][c] = 0;
        for (int k = 0; k < MSize; k++)
          d.a[r][c] += a[r][k] * b.a[k][c];
      }
    return d;
  }
