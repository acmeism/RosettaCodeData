R=: 10x #. #&1
assert 11111111111111111111111111111111x -: R 32

Filter=: (#~`)(`:6)

rotations=: (|."0 1~ i.@#)&.(10&#.inv)
assert 123 231 312 -: rotations 123

primes_less_than=: i.&.:(p:inv)
assert 2 3 5 7 11 -: primes_less_than 12


NB. circular y --> y is the order of magnitude.
circular=: monad define
 P25=: ([: -. (0 e. 1 3 7 9 e.~ 10 #.inv ])&>)Filter primes_less_than 10^y  NB. Q25 are primes with 1 3 7 9 digits
 P=: 2 5 , P25
 en=: # P
 group=: en # 0
 next=: 1
 for_i. i. # group do.
  if. 0 = i { group do.       NB. if untested
   j =: P i. rotations i { P   NB. j are the indexes of the rotated numbers in the list of primes
   if. en e. j do.             NB. if any are unfound
    j=: j -. en                 NB. prepare to mark them all as searched, and failed.
    g=: _1
   else.
    g=: next                    NB. mark the set as found in a new group.  Because we can.
    next=: >: next
   end.
   group=: g j} group          NB. apply the tested mark
  end.
 end.
 group </. P
)
