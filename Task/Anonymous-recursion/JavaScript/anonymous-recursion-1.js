function fibo(n) {
  if (n < 0) { throw "Argument cannot be negative"; }

  return (function(n) {
    return (n < 2) ? 1 : arguments.callee(n-1) + arguments.callee(n-2);
  })(n);
}
