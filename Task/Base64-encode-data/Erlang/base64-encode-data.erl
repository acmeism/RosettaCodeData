-module(base64demo).
-export([main/0]).

main() ->
    {ok, Data} = file:read_file("favicon.ico"),
    Encoded = encode_library(Data),
    io:format("~s",[Encoded]).

%% Demonstrating with the library function.
encode_library(Data) ->
    base64:encode(Data).
