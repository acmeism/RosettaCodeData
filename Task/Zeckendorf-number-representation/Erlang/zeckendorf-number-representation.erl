% Function to generate a list of the first N Zeckendorf numbers
number(N) ->
    number_helper(N, 0, 0, []).

number_helper(0, _, _, Acc) ->
    lists:reverse(Acc);
number_helper(N, Curr, Index, Acc) ->
    case zn_loop(Curr) of
        {Bin, Next} ->
            number_helper(N - 1, Next, Index + 1, [{Bin, Index} | Acc])
    end.

% Helper function to find the next Zeckendorf number
zn_loop(N) ->
    Bin = my_integer_to_binary(N),
    case re:run(Bin, "11", [{capture, none}]) of
        match ->
            zn_loop(N + 1);
        nomatch ->
            {Bin, N + 1}
    end.

% Convert an integer to its binary representation as a string
my_integer_to_binary(N) ->
    lists:flatten(io_lib:format("~.2B", [N])).

% Test function to output the first 21 Zeckendorf numbers
main([]) ->
    ZnNumbers = number(21),
    lists:foreach(
        fun({Zn, I}) ->
            io:format("~p: ~s~n", [I, Zn])
        end, ZnNumbers).
