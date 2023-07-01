longestHailstoneSequence(M, Seq, Len) :- longesthailstone(M, 1, 1, Seq, Len).
longesthailstone(1, Cn, Cl, Mn, Ml):- Mn = Cn,
	                               Ml = Cl.
longesthailstone(N, _, Cl, Mn, Ml) :- hailstone(N, X),
                                       length(X, L),
                                       Cl < L,
                                       N1 is N-1,
                                       longesthailstone(N1, N, L, Mn, Ml).
longesthailstone(N, Cn, Cl, Mn, Ml) :- N1 is N-1,
                                       longesthailstone(N1, Cn, Cl, Mn, Ml).
