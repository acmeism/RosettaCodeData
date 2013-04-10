% -spec attribute is for documentation and dialyzer static analysis purposes only.
% It does not constrain the function like a guard (when ... ).
-spec exp_int(X :: integer(), N :: non_neg_integer()) -> integer().

% X ^ 0
exp_int(X, 0) when is_integer(X) -> % is_integer guard is required, otherwise X would match anything.
    1;

% X ^ odd
exp_int(X, N) when is_integer(X), N >= 1, N rem 2 == 1 ->
    Part = exp_int(X, (N-1) div 2),
    X * Part * Part;

% X ^ even
exp_int(X, N) when is_integer(X), N >= 2, N rem 2 == 0 ->
    Part = exp_int(X, N div 2),
    Part * Part.

% X ^ negative is excluded because it would return float.
