-module(cartesian).
-export([product/2]).

product(S1, S2) -> [{A,B} || A <- S1, B <- S2].
