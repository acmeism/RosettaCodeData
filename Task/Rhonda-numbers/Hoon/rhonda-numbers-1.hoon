::
::  A library for producing Rhonda numbers and testing if numbers are Rhonda.
::
::    A number is Rhonda if the product of its digits of in base b equals
::    the product of the base b and the sum of its prime factors.
::    see also: https://mathworld.wolfram.com/RhondaNumber.html
::
=<
::
|%
::  +check: test whether the number n is Rhonda to base b
::
++  check
  |=  [b=@ud n=@ud]
  ^-  ?
  ~_  leaf+"base b must be >= 2"
  ?>  (gte b 2)
  ~_  leaf+"candidate number n must be >= 2"
  ?>  (gte n 2)
  ::
  .=  (roll (base-digits b n) mul)
  %+  mul
    b
  (roll (prime-factors n) add)
::  +series: produce the first n numbers which are Rhonda in base b
::
::    produce ~ if base b has no Rhonda numbers
::
++  series
  |=  [b=@ud n=@ud]
  ^-  (list @ud)
  ~_  leaf+"base b must be >= 2"
  ?>  (gte b 2)
  ::
  ?:  =((prime-factors b) ~[b])
    ~
  =/  candidate=@ud  2
  =+  rhondas=*(list @ud)
  |-
  ?:  =(n 0)
    (flop rhondas)
  =/  is-rhonda=?  (check b candidate)
  %=  $
    rhondas    ?:(is-rhonda [candidate rhondas] rhondas)
    n          ?:(is-rhonda (dec n) n)
    candidate  +(candidate)
  ==
--
::
|%
::  +base-digits: produce a list of the digits of n represented in base b
::
::    This arm has two behaviors which may be at first surprising, but do not
::    matter for the purposes of the ++check and ++series arms, and allow for
::    some simplifications to its implementation.
::    - crashes on n=0
::    - orders the list of digits with least significant digits first
::
::    ex: (base-digits 4 10.206) produces ~[2 3 1 3 3 1 2]
::
++  base-digits
  |=  [b=@ud n=@ud]
  ^-  (list @ud)
  ?>  (gte b 2)
  ?<  =(n 0)
  ::
  |-
  ?:  =(n 0)
    ~
  :-  (mod n b)
  $(n (div n b))
::  +prime-factors: produce a list of the prime factors of n
::
::    by trial division
::    n must be >= 2
::    if n is prime, produce ~[n]
::    ex: (prime-factors 10.206) produces ~[7 3 3 3 3 3 3 2]
::
++  prime-factors
  |=  [n=@ud]
  ^-  (list @ud)
  ?>  (gte n 2)
  ::
  =+  factors=*(list @ud)
  =/  wheel  new-wheel
  ::  test candidates as produced by the wheel, not exceeding sqrt(n)
  ::
  |-
  =^  candidate  wheel  (next:wheel)
  ?.  (lte (mul candidate candidate) n)
    ?:((gth n 1) [n factors] factors)
  |-
  ?:  =((mod n candidate) 0)
    ::  repeat the prime factor as many times as possible
    ::
    $(factors [candidate factors], n (div n candidate))
  ^$
::  +new-wheel: a door for generating numbers that may be prime
::
::    This uses wheel factorization with a basis of {2, 3, 5} to limit the
::    number of composites produced. It produces numbers in increasing order
::    starting from 2.
::
++  new-wheel
  =/  fixed=(list @ud)  ~[2 3 5 7]
  =/  skips=(list @ud)  ~[4 2 4 2 4 6 2 6]
  =/  lent-fixed=@ud  (lent fixed)
  =/  lent-skips=@ud  (lent skips)
  ::
  |_  [current=@ud fixed-i=@ud skips-i=@ud]
  ::  +next: produce the next number and the new wheel state
  ::
  ++  next
    |.
    ::  Exhaust the numbers in fixed. Then calculate successive values by
    ::  cycling through skips and increasing from the previous number by
    ::  the current skip-value.
    ::
    =/  fixed-done=?  =(fixed-i lent-fixed)
    =/  next-fixed-i  ?:(fixed-done fixed-i +(fixed-i))
    =/  next-skips-i  ?:(fixed-done (mod +(skips-i) lent-skips) skips-i)
    =/  next
    ?.  fixed-done
      (snag fixed-i fixed)
    (add current (snag skips-i skips))
    :-  next
    +.$(current next, fixed-i next-fixed-i, skips-i next-skips-i)
  --
--
