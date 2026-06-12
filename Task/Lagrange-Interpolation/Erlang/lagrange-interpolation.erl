-module(lagrange_interpolation).

% Main function
main(_) ->
    Points = [{1, 1}, {2, 4}, {3, 1}, {4, 5}],
    Result = lagrange_interpolation(Points),
    display(Result),
    ok.

% Lagrange interpolation function
lagrange_interpolation(Points) ->
    NumPoints = length(Points),
    Polys = create_polys(Points, NumPoints, 0, []),

    % Apply weights and sum up
    WeightedPolys = weighted_polys(Points, Polys, NumPoints, 0, []),
    lists:foldl(fun(Poly, Acc) -> add(Acc, Poly) end, [0.0], WeightedPolys).

% Create all polynomial basis functions
create_polys(_Points, NumPoints, I, Acc) when I >= NumPoints ->
    lists:reverse(Acc);
create_polys(Points, NumPoints, I, Acc) ->
    Poly = create_poly(Points, NumPoints, I),
    create_polys(Points, NumPoints, I + 1, [Poly | Acc]).

% Create a single polynomial basis function
create_poly(Points, NumPoints, I) ->
    % Start with polynomial [1.0]
    BasePoly = [1.0],
    % Create the product of (x - x_j) for all j != i
    Poly = create_product(Points, NumPoints, I, 0, BasePoly),
    % Get x coordinate of current point
    {X, _} = lists:nth(I + 1, Points),
    % Evaluate polynomial at x_i
    Value = evaluate(Poly, X),
    % Divide by the value
    scalar_divide(Poly, Value).

% Create product of (x - x_j) factors
create_product(_Points, NumPoints, _I, J, Poly) when J >= NumPoints ->
    Poly;
create_product(Points, NumPoints, I, J, Poly) when I =:= J ->
    create_product(Points, NumPoints, I, J + 1, Poly);
create_product(Points, NumPoints, I, J, Poly) ->
    {X, _} = lists:nth(J + 1, Points),
    NewPoly = multiply(Poly, [-X, 1.0]),
    create_product(Points, NumPoints, I, J + 1, NewPoly).

% Apply weights to polynomials
weighted_polys(_Points, _Polys, NumPoints, I, Acc) when I >= NumPoints ->
    lists:reverse(Acc);
weighted_polys(Points, Polys, NumPoints, I, Acc) ->
    {_, Y} = lists:nth(I + 1, Points),
    Poly = lists:nth(I + 1, Polys),
    WeightedPoly = scalar_multiply(Poly, Y),
    weighted_polys(Points, Polys, NumPoints, I + 1, [WeightedPoly | Acc]).

% Add two polynomials
add(P1, P2) ->
    Len1 = length(P1),
    Len2 = length(P2),
    MaxLen = max(Len1, Len2),
    P1Padded = P1 ++ lists:duplicate(MaxLen - Len1, 0.0),
    P2Padded = P2 ++ lists:duplicate(MaxLen - Len2, 0.0),
    lists:zipwith(fun(A, B) -> A + B end, P1Padded, P2Padded).

% Multiply two polynomials
multiply(P1, P2) ->
    Len1 = length(P1),
    Len2 = length(P2),
    ResultLen = Len1 + Len2 - 1,
    Result = lists:duplicate(ResultLen, 0.0),
    multiply_helper(P1, P2, Len1, Len2, Result).

multiply_helper(P1, P2, Len1, Len2, Result) ->
    Indices = [{I, J} || I <- lists:seq(0, Len1-1), J <- lists:seq(0, Len2-1)],
    lists:foldl(fun({I, J}, Acc) ->
                    Idx = I + J,
                    Val = lists:nth(I+1, P1) * lists:nth(J+1, P2),
                    update_list(Acc, Idx, Val)
                end, Result, Indices).

% Helper to update a list at a specific index
update_list(List, Idx, Val) ->
    lists:sublist(List, Idx) ++
    [lists:nth(Idx+1, List) + Val] ++
    lists:nthtail(Idx+1, List).

% Scalar multiply a polynomial
scalar_multiply(Poly, Scalar) ->
    lists:map(fun(X) -> X * Scalar end, Poly).

% Scalar divide a polynomial
scalar_divide(Poly, Divisor) ->
    scalar_multiply(Poly, 1.0 / Divisor).

% Evaluate a polynomial at point x
evaluate(Poly, X) ->
    lists:foldl(fun(Coef, Acc) -> Acc * X + Coef end, 0.0, lists:reverse(Poly)).

% Display a polynomial
display(Poly) ->
    case length(Poly) of
        1 ->
            io:format("~.5f~n", [hd(Poly)]);
        _ ->
            Degree = length(Poly) - 1,
            Format = format_polynomial(Poly, Degree),
            io:format("~s~n", [Format])
    end.

% Format a polynomial as a string
format_polynomial(Poly, Degree) ->
    Terms = [format_term(I, lists:nth(I+1, Poly), Degree) ||
             I <- lists:seq(Degree, 0, -1),
             lists:nth(I+1, Poly) =/= 0.0],
    case Terms of
        [] -> "0";
        _ -> lists:flatten(Terms)
    end.

% Format a single term of the polynomial
format_term(Power, Coef, Degree) ->
    AbsCoef = abs(Coef),
    Sign = if
            Coef < 0.0 -> if Power =:= Degree -> "-"; true -> " - " end;
            Power < Degree -> " + ";
            true -> ""
          end,

    CoefStr = if
                AbsCoef =:= 1.0, Power > 0 -> "";
                true -> io_lib:format("~.5f", [AbsCoef])
              end,

    Term = case Power of
            0 -> if AbsCoef =:= 1.0 -> "1"; true -> "" end;
            1 -> "x";
            _ -> io_lib:format("x^~w", [Power])
          end,

    Sign ++ CoefStr ++ Term.
