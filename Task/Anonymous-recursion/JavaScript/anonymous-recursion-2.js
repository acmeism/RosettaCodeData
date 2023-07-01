function fibo(n) {
  if (n < 0) { throw "Argument cannot be negative"; }

  return (function fib(n) {
    return (n < 2) ? n : fib(n-1) + fib(n-2);
  })(n);
}
