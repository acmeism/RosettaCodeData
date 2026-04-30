-module(matrix).
-export([new/1, get_rows/1, get_cols/1, add/2, subtract/2, multiply/2,
         strassen/2, to_string/1, to_string_with_precision/2, main/1]).

-record(matrix, {data, rows, cols}).

% Constructor
new(Data) ->
    Rows = length(Data),
    Cols = case Rows of
        0 -> 0;
        _ -> length(hd(Data))
    end,
    #matrix{data = Data, rows = Rows, cols = Cols}.

% Getters
get_rows(#matrix{rows = Rows}) -> Rows.
get_cols(#matrix{cols = Cols}) -> Cols.

% Validation functions
validate_dimensions(M1, M2) ->
    case get_rows(M1) =:= get_rows(M2) andalso get_cols(M1) =:= get_cols(M2) of
        true -> ok;
        false -> error("Matrices must have the same dimensions.")
    end.

validate_multiplication(M1, M2) ->
    case get_cols(M1) =:= get_rows(M2) of
        true -> ok;
        false -> error("Cannot multiply these matrices.")
    end.

validate_square_power_of_two(M) ->
    Rows = get_rows(M),
    Cols = get_cols(M),
    case Rows =:= Cols of
        false -> error("Matrix must be square.");
        true ->
            case Rows =:= 0 orelse (Rows band (Rows - 1)) =/= 0 of
                true -> error("Size of matrix must be a power of two.");
                false -> ok
            end
    end.

% Matrix operations
add(M1, M2) ->
    validate_dimensions(M1, M2),
    Data1 = M1#matrix.data,
    Data2 = M2#matrix.data,
    ResultData = add_rows(Data1, Data2),
    new(ResultData).

add_rows([], []) -> [];
add_rows([Row1|Rest1], [Row2|Rest2]) ->
    [add_elements(Row1, Row2) | add_rows(Rest1, Rest2)].

add_elements([], []) -> [];
add_elements([E1|Rest1], [E2|Rest2]) ->
    [E1 + E2 | add_elements(Rest1, Rest2)].

subtract(M1, M2) ->
    validate_dimensions(M1, M2),
    Data1 = M1#matrix.data,
    Data2 = M2#matrix.data,
    ResultData = subtract_rows(Data1, Data2),
    new(ResultData).

subtract_rows([], []) -> [];
subtract_rows([Row1|Rest1], [Row2|Rest2]) ->
    [subtract_elements(Row1, Row2) | subtract_rows(Rest1, Rest2)].

subtract_elements([], []) -> [];
subtract_elements([E1|Rest1], [E2|Rest2]) ->
    [E1 - E2 | subtract_elements(Rest1, Rest2)].

multiply(M1, M2) ->
    validate_multiplication(M1, M2),
    Data1 = M1#matrix.data,
    Data2 = M2#matrix.data,
    Cols2 = get_cols(M2),
    ResultData = multiply_rows(Data1, Data2, Cols2),
    new(ResultData).

multiply_rows([], _Data2, _Cols2) -> [];
multiply_rows([Row|Rest], Data2, Cols2) ->
    ResultRow = multiply_row_with_matrix(Row, Data2, Cols2),
    [ResultRow | multiply_rows(Rest, Data2, Cols2)].

multiply_row_with_matrix(Row, Data2, Cols2) ->
    [dot_product(Row, get_column(Data2, J)) || J <- lists:seq(1, Cols2)].

get_column(Data, ColIndex) ->
    [lists:nth(ColIndex, Row) || Row <- Data].

dot_product(List1, List2) ->
    lists:sum([E1 * E2 || {E1, E2} <- lists:zip(List1, List2)]).

% String representation
to_string(M) ->
    Data = M#matrix.data,
    RowsStr = [format_row(Row) || Row <- Data],
    string:join(RowsStr, "\n") ++ "\n".

format_row(Row) ->
    Elements = [format_element(E) || E <- Row],
    "[" ++ string:join(Elements, ", ") ++ "]".

format_element(E) ->
    io_lib:format("~w", [E]).

to_string_with_precision(M, P) ->
    Data = M#matrix.data,
    Pow = math:pow(10.0, P),
    RowsStr = [format_row_with_precision(Row, Pow, P) || Row <- Data],
    string:join(RowsStr, "\n") ++ "\n".

format_row_with_precision(Row, Pow, P) ->
    Elements = [format_element_with_precision(E, Pow, P) || E <- Row],
    "[" ++ string:join(Elements, ", ") ++ "]".

format_element_with_precision(E, Pow, P) ->
    Rounded = round(E * Pow) / Pow,
    Formatted = io_lib:format("~." ++ integer_to_list(P) ++ "f", [Rounded]),
    FormattedStr = lists:flatten(Formatted),
    % Handle negative zero
    ZeroCheck = case P of
        0 -> "0";
        _ -> "0." ++ lists:duplicate(P, $0)
    end,
    case FormattedStr of
        "-" ++ Rest when Rest =:= ZeroCheck -> ZeroCheck;
        _ -> FormattedStr
    end.

% Strassen multiplication helper functions
to_quarters(M) ->
    Rows = get_rows(M),
    R = Rows div 2,
    Data = M#matrix.data,

    % Extract quarters directly
    TopHalf = lists:sublist(Data, R),
    BottomHalf = lists:nthtail(R, Data),

    % Q0: top-left, Q1: top-right, Q2: bottom-left, Q3: bottom-right
    Q0_Data = [lists:sublist(Row, R) || Row <- TopHalf],
    Q1_Data = [lists:nthtail(R, Row) || Row <- TopHalf],
    Q2_Data = [lists:sublist(Row, R) || Row <- BottomHalf],
    Q3_Data = [lists:nthtail(R, Row) || Row <- BottomHalf],

    [new(Q0_Data), new(Q1_Data), new(Q2_Data), new(Q3_Data)].

from_quarters([Q0, Q1, Q2, Q3]) ->
    Q0_Data = Q0#matrix.data,
    Q1_Data = Q1#matrix.data,
    Q2_Data = Q2#matrix.data,
    Q3_Data = Q3#matrix.data,

    % Combine quarters back into full matrix
    TopHalf = [Row0 ++ Row1 || {Row0, Row1} <- lists:zip(Q0_Data, Q1_Data)],
    BottomHalf = [Row2 ++ Row3 || {Row2, Row3} <- lists:zip(Q2_Data, Q3_Data)],

    new(TopHalf ++ BottomHalf).

strassen(M1, M2) ->
    validate_square_power_of_two(M1),
    validate_square_power_of_two(M2),
    case get_rows(M1) =:= get_rows(M2) andalso get_cols(M1) =:= get_cols(M2) of
        false -> error("Matrices must be square and of equal size for Strassen multiplication.");
        true -> strassen_impl(M1, M2)
    end.

strassen_impl(M1, M2) ->
    case get_rows(M1) of
        1 -> multiply(M1, M2);
        _ ->
            [A11, A12, A21, A22] = to_quarters(M1),
            [B11, B12, B21, B22] = to_quarters(M2),

            % Calculate the 7 products according to Strassen's algorithm
            P1 = strassen_impl(A11, subtract(B12, B22)),
            P2 = strassen_impl(add(A11, A12), B22),
            P3 = strassen_impl(add(A21, A22), B11),
            P4 = strassen_impl(A22, subtract(B21, B11)),
            P5 = strassen_impl(add(A11, A22), add(B11, B22)),
            P6 = strassen_impl(subtract(A12, A22), add(B21, B22)),
            P7 = strassen_impl(subtract(A11, A21), add(B11, B12)),

            % Calculate result quarters
            C11 = add(subtract(add(P5, P4), P2), P6),
            C12 = add(P1, P2),
            C21 = add(P3, P4),
            C22 = subtract(subtract(add(P5, P1), P3), P7),

            from_quarters([C11, C12, C21, C22])
    end.

% Main function for testing
main(_) ->
    AData = [[1.0, 2.0], [3.0, 4.0]],
    A = new(AData),

    BData = [[5.0, 6.0], [7.0, 8.0]],
    B = new(BData),

    CData = [[1.0, 1.0, 1.0, 1.0], [2.0, 4.0, 8.0, 16.0], [3.0, 9.0, 27.0, 81.0], [4.0, 16.0, 64.0, 256.0]],
    C = new(CData),

    DData = [[4.0, -3.0, 4.0/3.0, -1.0/4.0],
             [-13.0/3.0, 19.0/4.0, -7.0/3.0, 11.0/24.0],
             [3.0/2.0, -2.0, 7.0/6.0, -1.0/4.0],
             [-1.0/6.0, 1.0/4.0, -1.0/6.0, 1.0/24.0]],
    D = new(DData),

    EData = [[1.0, 2.0, 3.0, 4.0], [5.0, 6.0, 7.0, 8.0], [9.0, 10.0, 11.0, 12.0], [13.0, 14.0, 15.0, 16.0]],
    E = new(EData),

    FData = [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]],
    F = new(FData),

    io:format("Using 'normal' matrix multiplication:~n"),
    io:format("  a * b = ~s~n", [to_string(multiply(A, B))]),
    io:format("  c * d = ~s~n", [to_string_with_precision(multiply(C, D), 6)]),
    io:format("  e * f = ~s~n", [to_string(multiply(E, F))]),

    io:format("~nUsing 'Strassen' matrix multiplication:~n"),
    io:format("  a * b = ~s~n", [to_string(strassen(A, B))]),
    io:format("  c * d = ~s~n", [to_string_with_precision(strassen(C, D), 6)]),
    io:format("  e * f = ~s~n", [to_string(strassen(E, F))]).
