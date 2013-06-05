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
        static double calc(double n)
        {
          if(n < 2)
          {
            return n;
          }
          else
          {
            return calc(n-1) + calc(n-2);
          }
        }
    };

    return actual_fib::calc(n);
  }
}
