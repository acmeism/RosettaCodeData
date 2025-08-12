-module(matrix_arithmetic).
-export([main/1, det/1, perm/1, minor/3]).

minor(A, X, Y) ->
    Length = length(A) - 1,
    [begin
        [begin
            if
                I < X, J < Y -> lists:nth(J+1, lists:nth(I+1, A));
                I >= X, J < Y -> lists:nth(J+1, lists:nth(I+2, A));
                I < X, J >= Y -> lists:nth(J+2, lists:nth(I+1, A));
                true -> lists:nth(J+2, lists:nth(I+2, A))
            end
        end || J <- lists:seq(0, Length-1)]
    end || I <- lists:seq(0, Length-1)].

det(A) ->
    case length(A) of
        1 ->
            lists:nth(1, lists:nth(1, A));
        _ ->
            lists:foldl(fun(I, Sum) ->
                Sign = case I rem 2 of
                    0 -> 1;
                    _ -> -1
                end,
                Sum + Sign * lists:nth(I+1, lists:nth(1, A)) * det(minor(A, 0, I))
            end, 0, lists:seq(0, length(A)-1))
    end.

perm(A) ->
    case length(A) of
        1 ->
            lists:nth(1, lists:nth(1, A));
        _ ->
            lists:foldl(fun(I, Sum) ->
                Sum + lists:nth(I+1, lists:nth(1, A)) * perm(minor(A, 0, I))
            end, 0, lists:seq(0, length(A)-1))
    end.

main(_) ->
    % Using the provided test matrix
    M = [
        [0, 1, 2, 3, 4],
        [5, 6, 7, 8, 9],
        [10, 11, 12, 13, 14],
        [15, 16, 17, 18, 19],
        [20, 21, 22, 23, 24]
    ],

    io:format("Determinant: ~p~n", [det(M)]),
    io:format("Permanent: ~p~n", [perm(M)]).
