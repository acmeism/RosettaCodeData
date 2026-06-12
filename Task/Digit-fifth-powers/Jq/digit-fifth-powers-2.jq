# Output: an array of i^5 for i in 0 .. 9 inclusive
def dp5: [range(0;10) | power(5)];

def task:
  dp5 as $dp5
  | ($dp5[9] * 6) as $limit
  | sum( range(2; $limit + 1)
         | sum( digits | $dp5[.] ) as $s
         | select(. == $s) ) ;

"The sum of all numbers that can be written as the sum of the 5th powers of their digits is:", task
