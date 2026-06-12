def sumPhi($max):
  reduce range(1; max+1) as $n ({};
    .sumPhi += ($n|totient)
    | if $n | is_prime
      then .a[$n-1] = .a[$n-2]
      else
        .a[$n-1] = $n * ($n - 1) / 2 + 1 - .sumPhi
      end ) ;

def limits: [ 1, 10, 1e2, 1e3 ];

"Number of pairs with common factors - first one hundred terms:",
(sumPhi( limits[-1] )
 | (.a[0:100] | _nwise(10) | map(lpad(6)) | join(" ") ),
   ( limits[] as $i
     | "The #\($i) term: \(.a[$i-1])" ) )
