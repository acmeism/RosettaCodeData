nth(N, Batch) ->
	array:get(N-1, element(1, compact_array(N, Batch, [2, 3, 5]))).

compact_array(Goal, Lim, Primes) ->
	{Array, Candidates} = array(Lim, Primes),
	compact_array(Goal, Lim, Lim, Array, Candidates).

compact_array(Goal, _, Index, Array, Candidates) when Index > Goal ->
	{Array, Candidates};
compact_array(Goal, Lim, Index, Array, Candidates) ->
	{N_array, N_candidates} =
	        array(compact(Array, Candidates), Index + Lim, Index, Candidates),
	compact_array(Goal, Lim, Index+Lim, N_array, N_candidates).

compact(Array, L) ->
	Index = lists:min([element(2, V) || V <- L]),
	Keep = [E || E <- array:sparse_to_orddict(Array), element(1, E) >= Index],
	array:from_orddict(Keep).
