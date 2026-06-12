# For the stretch goal:
def count(s): reduce s as $x (null; .+1);

# $n is the max number of intervening digits
def task($n):
  3,
  (range(1; $n+1) as $power
   | (3 * pow(10; $power+1) + 3) as $min
   | ("3" + ((pow(10; $power) -1)|tostring) + "4"|tonumber) as $max
   | range($min; $max; 10)
   | select(is_prime)   ) ;

task(2),
 "\nStretch goal: \(count( task(4) ))"
