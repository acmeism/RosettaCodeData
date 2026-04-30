-module(long_multiplication).
-export([main/0]).

main() ->
    %% Erlang has a bit-shift operator "bsl" (bit shift left).
    %% "1 bsl 64" means "take the number 1 and shift it left by 64 bits".
    %% Shifting left is the same as multiplying by 2 for each shift.
    %% So: 1 bsl 64 = 2^64 exactly.
    Two64 = 1 bsl 64,

    %% Now we multiply 2^64 by 2^64.
    %% This is the same as (2^64)^2 = 2^128.
    Product = Two64 * Two64,

    %% We also compute 2^128 directly by shifting 1 left by 128 bits.
    Two128 = 1 bsl 128,

    %% Compare if the product we calculated is equal to the direct 2^128.
    %% Erlang integers are arbitrary precision (they grow as big as needed),
    %% so this works without overflow.
    Equal = (Product == Two128),

    %% Print results nicely with io:format.
    %% "~p" means "print as Erlang term".
    io:format("2^64 (decimal): ~p~n", [Two64]),
    io:format("(2^64) * (2^64) = (decimal):~n~p~n", [Product]),
    io:format("2^128 (decimal, direct): ~p~n", [Two128]),
    io:format("Product == 2^128 ? ~p~n", [Equal]),

    %% Just printing the expected decimal result explicitly.
    %% This is not really necessary since Erlang computed it already.
    io:format("Expected decimal for 2^128: 340282366920938463463374607431768211456~n", []),ok.
