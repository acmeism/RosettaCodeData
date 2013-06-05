double fib(double n)
{
  if(n < 0)
  {
    throw "Invalid argument passed to fib";
  }
  else
  {
    struct actual_fib
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
    };

    return actual_fib()(n);
  }
}
