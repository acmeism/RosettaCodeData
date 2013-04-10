function fibo(n) {
  if (n < 0)
    throw "Argument cannot be negative";
  else
    return (function fib(n) {
      if (n < 2)
        return 1;
      else
        return fib(n-1) + fib(n-2);
    })(n);
}
