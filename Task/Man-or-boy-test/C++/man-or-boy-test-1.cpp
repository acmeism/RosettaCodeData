#include <iostream>
#include <tr1/memory>
using std::tr1::shared_ptr;
using std::tr1::enable_shared_from_this;

struct Arg {
  virtual int run() = 0;
  virtual ~Arg() { };
};

int A(int, shared_ptr<Arg>, shared_ptr<Arg>, shared_ptr<Arg>,
      shared_ptr<Arg>, shared_ptr<Arg>);

class B : public Arg, public enable_shared_from_this<B> {
private:
  int k;
  const shared_ptr<Arg> x1, x2, x3, x4;

public:
  B(int _k, shared_ptr<Arg> _x1, shared_ptr<Arg> _x2, shared_ptr<Arg> _x3,
    shared_ptr<Arg> _x4)
    : k(_k), x1(_x1), x2(_x2), x3(_x3), x4(_x4) { }
  int run() {
    return A(--k, shared_from_this(), x1, x2, x3, x4);
  }
};

class Const : public Arg {
private:
  const int x;
public:
  Const(int _x) : x(_x) { }
  int run () { return x; }
};

int A(int k, shared_ptr<Arg> x1, shared_ptr<Arg> x2, shared_ptr<Arg> x3,
      shared_ptr<Arg> x4, shared_ptr<Arg> x5) {
  if (k <= 0)
    return x4->run() + x5->run();
  else {
    shared_ptr<Arg> b(new B(k, x1, x2, x3, x4));
    return b->run();
  }
}

int main() {
  std::cout << A(10, shared_ptr<Arg>(new Const(1)),
                 shared_ptr<Arg>(new Const(-1)),
                 shared_ptr<Arg>(new Const(-1)),
                 shared_ptr<Arg>(new Const(1)),
                 shared_ptr<Arg>(new Const(0))) << std::endl;
  return 0;
}
