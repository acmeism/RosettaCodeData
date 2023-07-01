|%
++  check
  |=  [n=@ud base=@ud]
  ::  if base is prime, automatic no
  ::
  ?:  =((~(gut by (prime-map +(base))) base 0) 0)
    %.n
  ::  if not multiply the digits and compare to base x sum of factors
  ::
  ?:  =((roll (digits [base n]) mul) (mul base (roll (factor n) add)))
    %.y
  %.n
++  series
  |=  [base=@ud many=@ud]
  =/  rhondas  *(list @ud)
  ?:  =((~(gut by (prime-map +(base))) base 0) 0)
    rhondas
  =/  itr  1
  |-
  ?:  =((lent rhondas) many)
    (flop rhondas)
  ?:  =((check itr base) %.n)
    $(itr +(itr))
  $(rhondas [itr rhondas], itr +(itr))
::  digits: gives the list of digits of a number in a base
::
::    We strip digits least to most significant.
::    The least significant digit (lsd) of n in base b is just n mod b.
::    Subtract the lsd, divide by b, and repeat.
::    To know when to stop, we need to know how many digits there are.
++  digits
  |=  [base=@ud num=@ud]
  ^-  (list @ud)
  |-
  =/  modulus=@ud  (mod num base)
  ?:  =((num-digits base num) 1)
    ~[modulus]
  [modulus $(num (div (sub num modulus) base))]
::  num-digits: gives the number of digits of a number in a base
::
::    Simple idea: k is the number of digits of n in base b if and
::    only if k is the smallest number such that b^k > n.
++  num-digits
  |=  [base=@ud num=@ud]
  ^-  @ud
  =/  digits=@ud  1
  |-
  ?:  (gth (pow base digits) num)
    digits
  $(digits +(digits))
::  factor: produce a list of prime factors
::
::    The idea is to identify "small factors" of n, i.e. prime factors less than
::    the square root. We then divide n by these factors to reduce the
::    magnitude of n. It's easy to argue that after this is done, we obtain 1
::    or the largest prime factor.
::
++  factor
  |=  n=@ud
  ^-  (list @ud)
  ?:  ?|(=(n 0) =(n 1))
    ~[n]
  =/  factorization  *(list @ud)
  ::  produce primes less than or equal to root n
  ::
  =/  root  (sqrt n)
  =/  primes  (prime-map +(root))
  ::  itr = iterate; we want to iterate through the primes less than root n
  ::
  =/  itr  2
  |-
  ?:  =(itr +(root))
  ::  if n is now 1 we're done
  ::
    ?:  =(n 1)
      factorization
    ::  otherwise it's now the original n's largest primes factor
    ::
    [n factorization]
  ::  if itr not prime move on
  ::
  ?:  =((~(gut by primes) itr 0) 1)
    $(itr +(itr))
  ::  if it is prime, divide out by the highest power that divides num
  ::
  ?:  =((mod n itr) 0)
    $(n (div n itr), factorization [itr factorization])
  ::  once done, move to next prime
  ::
  $(itr +(itr))
::  sqrt: gives the integer square root of a number
::
::    It's based on an algorithm that predates the Greeks:
::    To find the square root of A, think of A as an area.
::    Guess the side of the square x. Compute the other side y = A/x.
::    If x is an over/underestimate then y is an under/overestimate.
::    So (x+y)/2 is the average of an over and underestimate, thus better than x.
::    Repeatedly doing x --> (x + A/x)/2 converges to sqrt(A).
::
::    This algorithm is the same but with integer valued operations.
::    The algorithm either converges to the integer square root and repeats,
::    or gets trapped in a two-cycle of adjacent integers.
::    In the latter case, the smaller number is the answer.
::
++  sqrt
  |=  n=@ud
  =/  guess=@ud  1
  |-
  =/  new-guess  (div (add guess (div n guess)) 2)
  ::  sequence stabilizes
  ::
  ?:  =(guess new-guess)
    guess
  ::  sequence is trapped in 2-cycle
  ::
  ?:  =(guess +(new-guess))
    new-guess
  ?:  =(new-guess +(guess))
    guess
  $(guess new-guess)
::  prime-map: (effectively) produces primes less than a given input
::
::    This is the sieve of Eratosthenes to produce primes less than n.
::    I used a map because it had much faster performance than a list.
::    Any key in the map is a non-prime. The value 1 indicates "false."
::    I.e. it's not a prime.
++  prime-map
  |=  n=@ud
  ^-  (map @ud @ud)
  =/  prime-map  `(map @ud @ud)`(my ~[[0 1] [1 1]])
  ::  start sieving with 2
  ::
  =/  sieve  2
  |-
  ::  if sieve is too large to be a factor we're done
  ::
  ?:  (gte (mul sieve sieve) n)
    prime-map
  ::  if not too large but not prime, move on
  ::
  ?:  =((~(gut by prime-map) sieve 0) 1)
    $(sieve +(sieve))
  ::  sequence: explanation
  ::
  ::    If s is the sieve number, we start sieving multiples
  ::    of s at s^2 in sequence: s^2, s^2 + s, s^2 + 2s, ...
  ::    We start at s^2 because any number smaller than s^2
  ::    has prime factors less than s and would have been
  ::    eliminated earlier in the sieving process.
  ::
  =/  sequence  (mul sieve sieve)
  |-
  ::  done sieving with s once sequence is past n
  ::
  ?:  (gte sequence n)
    ^$(sieve +(sieve))
  ::  if sequence position is known not prime we move on
  ::
  ?:  =((~(gut by prime-map) sequence 0) 1)
    $(sequence (add sequence sieve))
  ::  otherwise we mark position of sequence as not prime and move on
  ::
  $(prime-map (~(put by prime-map) sequence 1), sequence (add sequence sieve))
--
