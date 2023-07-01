female(0,1).
female(N,F) :- N>0,
	       N1 is N-1,
	       female(N1,R),
	       male(R, R1),
	       F is N-R1.

male(0,0).
male(N,F) :- N>0,
	     N1 is N-1,
	     male(N1,R),
	     female(R, R1),
	     F is N-R1.
