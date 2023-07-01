def odd_gt2_is_prime:
  . as $n
  | if   ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else {i:23}
         | until( (.i * .i) > $n or ($n % .i == 0); .i += 2)
	 | .i * .i > $n
    end;

def twin_primes($max):
    {count:0, i:3, isprime:true}
    | until(.i >= $max;
        .i += 2
        | if .isprime
          then if .i|odd_gt2_is_prime then .count+=1 else .isprime = false end
          else .isprime = (.i|odd_gt2_is_prime)
	  end )
    | .count;

pow(10; range(1;8)) | "Number of twin primes less than \(.) is \(twin_primes(.))."
