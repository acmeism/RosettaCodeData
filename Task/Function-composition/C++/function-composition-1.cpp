#include <functional>
#include <cmath>
#include <iostream>

// functor class to be returned by compose function
template <class Fun1, class Fun2>
class compose_functor :
  public std::unary_function<typename Fun2::argument_type,
                             typename Fun1::result_type>
{
protected:
  Fun1 f;
  Fun2 g;

public:
  compose_functor(const Fun1& _f, const Fun2& _g)
    : f(_f), g(_g) { }

  typename Fun1::result_type
  operator()(const typename Fun2::argument_type& x) const
  { return f(g(x)); }
};

// we wrap it in a function so the compiler infers the template arguments
// whereas if we used the class directly we would have to specify them explicitly
template <class Fun1, class Fun2>
inline compose_functor<Fun1, Fun2>
compose(const Fun1& f, const Fun2& g)
{ return compose_functor<Fun1,Fun2>(f, g); }

int main() {
  std::cout << compose(std::ptr_fun(::sin), std::ptr_fun(::asin))(0.5) << std::endl;

  return 0;
}
