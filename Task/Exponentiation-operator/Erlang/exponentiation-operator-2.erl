% -spec attribute is for documentation and dialyzer static analysis purposes only.
% It does not constrain the function like a guard (when ... ).
-spec exp_float(X :: float(), N :: integer()) -> float().

% X ^ 0
exp_float(X, 0) when is_float(X) -> % is_float guard is required, otherwise X would match anything.
    1.0;

% X ^ negative
exp_float(X, N) when is_float(X), N < 0 ->
    1.0 / exp_float(X, -N);

% X ^ even
exp_float(X, N) when is_float(X), N >= 1, N rem 2 == 1 ->
    Part = exp_float(X, (N-1) div 2),
    X * Part * Part;

% X ^ odd
exp_float(X, N) when is_float(X), N >= 2, N rem 2 == 0 ->
    Part = exp_float(X, N div 2),
    Part * Part.
