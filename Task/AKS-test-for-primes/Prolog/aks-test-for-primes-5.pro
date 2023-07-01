   prime(N) :- optpascal([1,N|Xs]), forall( member(X,Xs), 0 is X mod N).
