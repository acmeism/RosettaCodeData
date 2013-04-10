function fibo(n) {
  if (n < 0)
    throw "Argument cannot be negative";
  else
    return (function(n) {
      if (n < 2)
        return 1;
      else
        return arguments.callee(n-1) + arguments.callee(n-2);
    })(n);
}
