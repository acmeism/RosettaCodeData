% Taken from RosettaCode Factorial page for Prolog
fact(X, 1) :- X<2.
fact(X, F) :- Y is X-1, fact(Y,Z), F is Z*X.
	
goal_expansion((X = factorial_of(N)), (X = F)) :- fact(N,F).
				
test :-	
	F = factorial_of(10),
	format('!10 = ~p~n', F).
