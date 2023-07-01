#include <exception>
struct MyException: std::exception
{
  virtual const char* what() const noexcept { return "description"; }
}
