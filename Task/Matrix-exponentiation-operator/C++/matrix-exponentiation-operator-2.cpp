  // C++ does not have a ** operator, instead, ^ (bitwise Xor) is used.
  Mx operator^(int n) {
    if (n < 0)
      throw "Negative exponent not implemented";

    Mx d = identity();
    for (Mx sq = *this; n > 0; sq = sq * sq, n /= 2)
      if (n % 2 != 0)
        d = d * sq;
    return d;
  }
};

typedef SqMx<> M3;
typedef complex<double> creal;

int main() {
  double q = sqrt(0.5);
  creal array[3][3] =
    {{creal(q,  0), creal(q, 0), creal(0, 0)},
     {creal(0, -q), creal(0, q), creal(0, 0)},
     {creal(0,  0), creal(0, 0), creal(0, 1)}};
  M3 m(array);

  cout << "m ^ 23=" << endl
       << (m ^ 23) << endl;

  return 0;
}
