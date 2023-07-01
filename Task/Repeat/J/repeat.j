   NB. ^: (J's power conjunction) repeatedly evaluates a verb.

   NB. Appending to a vector the sum of the most recent
   NB. 2 items can generate the Fibonacci sequence.

   (, [: +/ _2&{.)  (^:4)  0 1
0 1 1 2 3 5


   NB. Repeat an infinite number of times
   NB. computes the stable point at convergence

   cosine =: 2&o.

   cosine (^:_ ) 2    NB. 2 is the initial value
0.739085

   cosine 0.739085  NB. demonstrate the stable point x==Cos(x)
0.739085


   cosine^:(<_) 2  NB. show the convergence
2 _0.416147 0.914653 0.610065 0.819611 0.682506 0.775995 0.713725 0.755929 0.727635 0.74675 0.733901 0.742568 0.736735 0.740666 0.738019 0.739803 0.738602 0.739411 0.738866 0.739233 0.738986 0.739152 0.73904 0.739116 0.739065 0.739099 0.739076 0.739091 0.7...


   # cosine^:(<_) 2  NB. iteration tallyft
78

   f =: 3 :'smoutput ''hi'''

   f''
hi

   NB. pass verbs via a gerund
   repeat =: dyad def 'for_i. i.y do. (x`:0)0 end. EMPTY'

   (f`'')repeat 4
hi
hi
hi
hi



   NB. pass a verb directly to an adverb

   Repeat =: adverb def 'for_i. i.y do. u 0 end. EMPTY'

   f Repeat 4
hi
hi
hi
hi
