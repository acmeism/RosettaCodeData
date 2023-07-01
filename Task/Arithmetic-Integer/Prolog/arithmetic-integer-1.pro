print_expression_and_result(M, N, Operator) :-
    Expression =.. [Operator, M, N],
    Result is Expression,
    format('~w ~8|is ~d~n', [Expression, Result]).

arithmetic_integer :-
    read(M),
    read(N),
    maplist( print_expression_and_result(M, N), [+,-,*,//,rem,^] ).
