def hcSequence($limit):
  reduce range(3; $limit) as $n ([0,1,1];
    .[$n-1] as $p
    | .[$n] = .[$p] + .[$n-$p]);

def task($limit):
  hcSequence($limit) as $a
  | "     Range          Maximum",
    "----------------   --------",
    (foreach range(2; $limit) as $n ( {max: $a[1], pow2: 1, p:1 };
       ($a[$n] / $n) as $r
       | .emit = null
       | if $r > .max then .max=$r else . end
       | if ($n == .pow2 * 2)
         then .emit = "2 ^ \(.p-1) to 2 ^ \(.p)   \(.max)"
         | .pow2 *= 2
         | .p +=  1
         | .max = $r
	 else . end;
	 select(.emit).emit)),

     ( (first( range( $limit-1; 0; -1) as $n
          | if ($a[$n]/$n >= 0.55) then $n else empty end) ) // 0
          | "\nMallows' number = \(.)") ;

task( pow(2;20) + 1 )
