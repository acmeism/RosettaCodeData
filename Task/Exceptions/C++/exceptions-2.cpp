#include <exception>
struct MyException: std::exception
{
  char const* what() const throw() { return "description"; }
}
