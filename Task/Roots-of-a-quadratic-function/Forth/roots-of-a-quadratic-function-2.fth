: quadratic { F: a F: b F: c -- r1 r2 }
  b b f*  4e a f* c f* f-
  fdup f0< if abort" imaginary roots" then
  fsqrt
  b f0< if fnegate then b f+ fnegate 2e f/ a f/
  c a f/ fover f/ ;

\ test
1 set-precision
1e -1e6 1e quadratic fs. fs.     \ 1e-6 1e6
