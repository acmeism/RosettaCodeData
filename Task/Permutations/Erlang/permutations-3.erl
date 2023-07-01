-module(permute).

-export([permute/1]).

permute([]) -> [[]];
permute(L) -> zipper(L, [], []).

% Use zipper to pick up first element of permutation
zipper([], _, Acc) -> lists:reverse(Acc);
zipper([H|T], R, Acc) ->
  % place current member in front of all permutations
  % of rest of set - both sides of zipper
  prepend(H, permute(lists:reverse(R, T)),
    % pass zipper state for continuation
    T, [H|R], Acc).

prepend(_, [], T, R, Acc) -> zipper(T, R, Acc); % continue in zipper
prepend(X, [H|T], ZT, ZR, Acc) -> prepend(X, T, ZT, ZR, [[X|H]|Acc]).
