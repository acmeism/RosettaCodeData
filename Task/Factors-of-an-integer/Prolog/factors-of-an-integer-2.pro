smart_factors(N,Fs) :-
  integer(N) ,
  N > 0 ,
  setof( F , factor(N,F) , Fs )
  .

factor(N,F) :-
  L is floor(sqrt(N)) ,
  between(1,L,X) ,
  0 =:= N mod X ,
  ( F = X ; F is N // X )
  .
