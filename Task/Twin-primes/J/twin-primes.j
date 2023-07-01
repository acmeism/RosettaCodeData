tp=: 3 : '+/ (*. _2&(|.!.0)) 1 p: i. y'

NB. 3 : ''     explicitly define a "monad" (a one-argument function)
NB. i. y       list integers up to the provided argument
NB. 1 p:       create list of 0s, 1s where those ints are prime
NB. _2&(|.!.0) "shift" that list to the right by two, filling left side with 0
NB. (*. g) y   create a "hook". "and" together the original and shifted lists
NB.            the result will have a 1 only if that i, and i-2, are both prime
NB. +/         sum the and-ed list (get the number of twin pairs)
