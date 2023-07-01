list(N) -> array:to_list(element(1, array(N, [2, 3, 5]))).

nth(N) -> array:get(N-1, element(1, array(N, [2, 3, 5]))).

array(N, Primes) -> array(array:new(), N, 1, [{P, 1, P} || P <- Primes]).

array(Array, Max, Max, Candidates) -> {Array, Candidates};
array(Array, Max, I, Candidates) ->
	Smallest = smallest(Candidates),
 	N_array = array:set(I, Smallest, Array),
	array(N_array, Max, I+1, update(Smallest, N_array, Candidates)).

update(Val, Array, Candidates) -> [update_(Val, C, Array) || C <- Candidates].

update_(Val, {Val, Ind, Mul}, Array) ->
	{Mul*array:get(Ind, Array), Ind+1, Mul};
update_(_, X, _) -> X.

smallest(L) -> lists:min([element(1, V) || V <- L]).
