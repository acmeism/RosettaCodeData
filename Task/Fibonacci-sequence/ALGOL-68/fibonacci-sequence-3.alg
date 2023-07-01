PROC recursive fibonacci = (INT n)INT:
  ( n < 2 | n | fib(n-1) + fib(n-2));
