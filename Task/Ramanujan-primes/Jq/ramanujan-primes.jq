def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint(columns; wide):
  reduce _nwise(columns) as $row ("";
     . + ($row|map(lpad(wide)) | join(" ")) + "\n" );

# output: {count}
def primeCounter($limit):
  {count: [range(0; $limit) | 1] }
  | if ($limit > 0) then .count[0] = 0 else . end
  | if ($limit > 1) then .count[1] = 0 else . end
  | .count |= reduce range(4; $limit; 2) as $i (.; .[$i] = 0)
  | .p = 3
  | .sq = 9
  | until(.sq >= $limit;
        if (.count[.p] != 0)
        then .q = .sq
        | until (.q >= $limit;
                .count[.q] = 0
                | .q += (.p * 2) )
        else .
	end
        | .sq += ((.p + 1) * 4)
        | .p += 2 )
  | .sum = 0
  | reduce range(0; $limit) as $i (.;
      .sum += .count[$i]
      | .count[$i] = .sum ) ;

# input: {count}
def primeCount($n): if $n < 1 then 0 else .count[$n] end;

# 2n ln 2n < Rn < 4n ln 4n
def ramanujanMax(n): (4 * n * ((4*n)|log))|ceil;

# input: {count}
def ramanujanPrime($n):
  if ($n == 1) then 2
  else first( foreach range(ramanujanMax($n); 1+2*$n; -1) as $i (.emit=null;
        if ($i % 2 == 1) then .
        elif (primeCount($i) - primeCount(($i/2)|floor) < $n) then .emit=$i + 1
	else .
	end)
	| select(.emit).emit ) // 0
  end ;

# The tasks
primeCounter(1 + ramanujanMax(1e6))
| "The first 100 Ramanujan primes are:",
  ( [range(1;101) as $i | ramanujanPrime($i) ]
    | tprint(10; 5) ),
  "\nThe 1,000th Ramanujan prime is \(ramanujanPrime(1000))",

 "\nThe 10,000th Ramanujan prime is \(ramanujanPrime(10000))",

 "\nThe 100,000th Ramanujan prime is \(ramanujanPrime(100000))",

 "\nThe 1,000,000th Ramanujan prime is \(ramanujanPrime(1000000))"
