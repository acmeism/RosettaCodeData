// this function can throw any type of exception
void foo()
{
  throw MyException();
}

// this function can only throw the types of exceptions that are listed
void foo2() throw(MyException)
{
  throw MyException();
}

// this function turns any exceptions other than MyException into std::bad_exception
void foo3() throw(MyException, std::bad_exception)
{
  throw MyException();
}
