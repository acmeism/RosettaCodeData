   u=. [ NB. Function (left)
   n=. ] NB. Argument (right)
   sr=. [ apply f. ,&< NB. Self referring

   fac=. (1:`(n * u sr n - 1:)) @. (0 < n)
   fac f. Y 10
3628800

   Fib=. ((u sr n - 2:) + u sr n - 1:) ^: (1 < n)
   Fib f. Y 10
55
