#include <tr1/functional>
#include <iostream>

typedef std::tr1::function<int()> F;

static int A(int k, const F &x1, const F &x2, const F &x3, const F &x4, const F &x5);

struct B_class {
  int &k;
  const F x1, x2, x3, x4;
  B_class(int &_k, const F &_x1, const F &_x2, const F &_x3, const F &_x4) :
    k(_k), x1(_x1), x2(_x2), x3(_x3), x4(_x4) { }
  int operator()() const { return A(--k, *this, x1, x2, x3, x4); }
};

static int A(int k, const F &x1, const F &x2, const F &x3, const F &x4, const F &x5)
{
  F B = B_class(k, x1, x2, x3, x4);
  return k <= 0 ? x4() + x5() : B();
}

struct L {
  const int n;
  L(int _n) : n(_n) { }
  int operator()() const { return n; }
};

int main()
{
  std::cout << A(10, L(1), L(-1), L(-1), L(1), L(0)) << std::endl;
  return 0;
}
