-module(binary_string).
-compile([export_all]).

%% Erlang has very easy handling of binary strings. Using
%% binary/bitstring syntax the various task features will be
%% demonstrated.


%% Erlang has GC so destruction is not shown.
test() ->
    Binary = <<0,1,1,2,3,5,8,13>>, % binaries can be created directly
    io:format("Creation: ~p~n",[Binary]),
    Copy = binary:copy(Binary), % They can also be copied
    io:format("Copy: ~p~n",[Copy]),
    Compared = Binary =:= Copy, % They can be compared directly
    io:format("Equal: ~p = ~p ? ~p~n",[Binary,Copy,Compared]),
    Empty1 = size(Binary) =:= 0, % The empty binary would have size 0
    io:format("Empty: ~p ? ~p~n",[Binary,Empty1]),
    Empty2 = size(<<>>) =:= 0, % The empty binary would have size 0
    io:format("Empty: ~p ? ~p~n",[<<>>,Empty2]),
    Substring = binary:part(Binary,3,3),
    io:format("Substring: ~p [~b..~b] => ~p~n",[Binary,3,5,Substring]),
    Replace = binary:replace(Binary,[<<1>>],<<42>>,[global]),
    io:format("Replacement: ~p~n",[Replace]),
    Append = <<Binary/binary,21>>,
    io:format("Append: ~p~n",[Append]),
    Join = <<Binary/binary,<<21,34,55>>/binary>>,
    io:format("Join: ~p~n",[Join]).

%% Since the task also asks that we show how these can be reproduced
%% rather than just using BIFs, the following are some example
%% recursive functions reimplementing some of the above.

%% Empty string
is_empty(<<>>) ->
    true;
is_empty(_) ->
    false.

%% Replacement:
replace(Binary,Value,Replacement) ->
    replace(Binary,Value,Replacement,<<>>).

replace(<<>>,_,_,Acc) ->
    Acc;
replace(<<Value,Rest/binary>>,Value,Replacement,Acc) ->
    replace(Rest,Value,Replacement,<< Acc/binary, Replacement >>);
replace(<<Keep,Rest/binary>>,Value,Replacement,Acc) ->
    replace(Rest,Value,Replacement,<< Acc/binary, Keep >>).
