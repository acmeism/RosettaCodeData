brute_force_factors( N , Fs ) :-
  integer(N) ,
  N > 0 ,
  setof( F , ( between(1,N,F) , N mod F =:= 0 ) , Fs )
  .
