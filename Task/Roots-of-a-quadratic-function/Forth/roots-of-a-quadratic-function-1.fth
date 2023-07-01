: quadratic ( fa fb fc -- r1 r2 )
  frot frot
  ( c a b )
  fover 3 fpick f* -4e f*  fover fdup f* f+
  ( c a b det )
  fdup f0< if abort" imaginary roots" then
  fsqrt
  fover f0< if fnegate then
  f+ fnegate
  ( c a b-det )
  2e f/ fover f/
  ( c a r1 )
  frot frot f/ fover f/ ;
