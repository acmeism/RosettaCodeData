def task($limit):
  twins($limit) as $twins
 | ( "Non twin prime sums:",
     ( nonTwinSums($limit; $twins) as $ntps
       | $ntps, " Found \($ntps|length)" ) ),
   ("\nNon twin prime sums (including 1):",
     ( nonTwinSums($limit; [1] + $twins) as $ntps
       | $ntps, " Found \($ntps|length)" )) ;

# Example:
task(100000)
