double fib(const double n)
{
  if(n < 0)
  {
    throw "Invalid argument passed to fib";
  }
  else
  {
    class actual_fib
    {
      public:
        static double calc(const double n)
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
