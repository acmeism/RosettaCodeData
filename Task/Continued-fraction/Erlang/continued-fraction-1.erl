-module(continued).
-compile([export_all]).

pi_a (0) -> 3;
pi_a (_N) -> 6.

pi_b (N) ->
    (2*N-1)*(2*N-1).

sqrt2_a (0) ->
    1;
sqrt2_a (_N) ->
    2.

sqrt2_b (_N) ->
    1.

nappier_a (0) ->
    2;
nappier_a (N) ->
    N.

nappier_b (1) ->
    1;
nappier_b (N) ->
    N-1.

continued_fraction(FA,_FB,0) -> FA(0);
continued_fraction(FA,FB,N) ->
    continued_fraction(FA,FB,N-1,FB(N)/FA(N)).

continued_fraction(FA,_FB,0,Acc) -> FA(0) + Acc;
continued_fraction(FA,FB,N,Acc) ->
    continued_fraction(FA,FB,N-1,FB(N)/ (FA(N) + Acc)).

test_pi (N) ->
    continued_fraction(fun pi_a/1,fun pi_b/1,N).

test_sqrt2 (N) ->
    continued_fraction(fun sqrt2_a/1,fun sqrt2_b/1,N).

test_nappier (N) ->
    continued_fraction(fun nappier_a/1,fun nappier_b/1,N).
