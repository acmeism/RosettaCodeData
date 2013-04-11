#include <iostream>
#include <ostream>

void foo()
{
  std::cout << "Going to throw an exception.\n";
  throw 7; // almost any object can be thrown, including ints
  std::throw << "This output will never execute.\n";
}

void bar()
{
  std::cout << "Going to call foo().\n";
  foo();
  std::cout << "This will be skipped by the exception coming from foo.\n";
}

void baz()
{
  try // everything thrown from inside the following code block
  {   // will be covered by the following catch clauses
    std::cout << "Going to call bar().\n";
    bar();
    std::cout << "This will be skipped by the exception coming from foo.\n";
  }
  catch(...) // a simple catch-all, but doesn't give access to the thrown exception
  {
    std::cout << "An exception occured. I'll just throw it on.\n";
    throw; // without an argument, the caught exception is re-thrown
  }
  std::cout << "This will not be executed due to the re-throw in the catch block\n";
}

void foobar()
{
  try
  {
    baz();
  }
  catch(char const* s)
  {
    std::cout << "If foo had thrown a char const*, this code would be executed.\n";
    std::cout << "In that case, the thrown char const* would read " << s << ".\n";
  }
  catch(int i)
  {
    std::cout << "Caught an int, with value " << i << " (should be 7).\n";
    std::cout << "Not rethrowing the int.\n";
  }
  catch(...)
  {
    std::cout << "This catch-all doesn't get invoked because the catch(int) above\n"
              << "already took care of the exception (even if it had rethrown the\n"
              << "exception, this catch-all would not be invoked, because it's\n"
              << "only invoked for exceptions coming from the try block.\n";
  }
  std::cout << "This will be executed, since the exception was handled above, and not rethrown.\n";
}

int main()
{
  try
  {
    foobar();
  }
  catch(...)
  {
    std::cout << "The main function never sees the exception, because it's completely handled\n"
              << "inside foobar(). Thus this catch-all block never gets invoked.\n";
  }
}
