#! /usr/bin/escript

-import(lists, [all/2, seq/2, zip/2]).

iterate(F, X) -> fun() -> [X | iterate(F, F(X))] end.

take(0, _lazy) -> [];
take(N, Lazy) ->
    [Value | Next] = Lazy(),
    [Value | take(N-1, Next)].


pascal() -> iterate(fun (Row) -> [1 | sum_adj(Row)] end, [1]).

sum_adj([_] = L) -> L;
sum_adj([A, B | _] = Row) -> [A+B | sum_adj(tl(Row))].


show_binomial(Row) ->
    Degree = length(Row) - 1,
    ["(x - 1)^",  integer_to_list(Degree), " =", binomial_rhs(Row, 1, Degree)].

show_x(0) -> "";
show_x(1) -> "x";
show_x(N) -> [$x, $^ | integer_to_list(N)].

binomial_rhs([], _, _) -> [];
binomial_rhs([Coef | Coefs], Sgn, Exp) ->
    SignChar = if Sgn > 0 -> $+; true -> $- end,
    [$ , SignChar, $ , integer_to_list(Coef), show_x(Exp) | binomial_rhs(Coefs, -Sgn, Exp-1)].


primerow(Row, N) -> all(fun (Coef) -> (Coef =:= 1) or (Coef rem N =:= 0) end, Row).

main(_) ->
    [io:format("~s~n", [show_binomial(Row)]) || Row <- take(8, pascal())],
    io:format("~nThe primes upto 50: ~p~n",
               [[N || {Row, N} <- zip(tl(tl(take(51, pascal()))), seq(2, 50)),
                      primerow(Row, N)]]).
