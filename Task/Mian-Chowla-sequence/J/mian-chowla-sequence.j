NB. http://rosettacode.org/wiki/Mian-Chowla_sequence

NB. Dreadfully inefficient implementation recomputes all the sums to n-1
NB. and computes the full addition table rather than just a triangular region
NB. However, this implementation is sufficiently quick to meet the requirements.

NB. The vector head is the next speculative value
NB. Beheaded, the vector is Mian-Chowla sequence.


Until =: conjunction def 'u^:(0 = v)^:_'
unique =: -:&# ~.   NB. tally of list matches that of set

next_mc =: [: (, {.) (>:@:{. , }.)Until(unique@:((<:/~@i.@# #&, +/~)@:(}. , {.)))


prime_q =: 1&p:   NB. for fun look at prime generation suitability
