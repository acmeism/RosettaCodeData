# The number of prime factors (as in prime factorization)
def numfactors:
  . as $num
  | reduce range(1; 1 + sqrt|floor) as $i (null;
       if ($num % $i) == 0
       then ($num / $i) as $r
       | if $i == $r then .+1 else .+2 end
       else .
       end );

# Output: a stream
def A06954:
  foreach range(1; infinite) as $i ({k: 0};
     .j = .k + 1
     | until( $i == (.j | numfactors); .j += 1)
     | .k = .j ;
     .j ) ;

"First 15 terms of OEIS sequence A069654: ",
[limit(15; A06954)]
