def f, m  // recursive closures must be declared before they are defined
f = { n -> n == 0 ? 1 : n - m(f(n-1)) }
m = { n -> n == 0 ? 0 : n - f(m(n-1)) }
