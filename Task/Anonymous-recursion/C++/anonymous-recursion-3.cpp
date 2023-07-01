double fib(double n)
{
  if(n < 0)
  {
    throw "Invalid argument passed to fib";
  }
  else
  {
    struct
    {
      double operator()(double n)
      {
        if(n < 2)
        {
          return n;
        }
        else
        {
          return (*this)(n-1) + (*this)(n-2);
        }
      }
    } actual_fib;

    return actual_fib(n);
  }
}
