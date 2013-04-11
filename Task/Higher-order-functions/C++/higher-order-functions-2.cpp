#include <iostream>
#include <functional>

template<class Func>
typename Func::result_type first(Func func, typename Func::argument_type arg)
{
  return func(arg);
}

class second : public std::unary_function<int, int>
{
public:
  result_type operator()(argument_type arg) const
  {
    return arg * arg;
  }
};

int main()
{
  std::cout << first(second(), 2) << std::endl;
  return 0;
}
