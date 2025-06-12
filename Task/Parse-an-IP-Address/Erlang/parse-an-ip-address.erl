#!/usr/bin/env escript
-module(ipparse).

-export([main/1]).

main([]) ->
    [print(A, parse(A)) || A <- data()],
    erlang:halt(0);
main(Args) ->
    [print(A, parse(A)) || A <- Args],
    erlang:halt(0).

-spec parse(Input :: string()) ->
	  {Family :: 'IPv6' | 'IPv4', Hex :: binary(), Port :: string()} |
	  {Family :: 'IPv6' | 'IPv4', Hex :: binary()}.
parse([$[ | Addr0]) ->
    case string:split(Addr0, "]", trailing) of
	[Addr] ->
	    {"IPv6", to_hex(inet:parse_address(Addr))};
	[Addr, [$: | Port]] ->
	    {"IPv6", to_hex(inet:parse_address(Addr)), Port}
    end;
parse(Addr0) ->
    case inet:parse_address(Addr0) of
	{error, einval} ->
	    [Addr, Port] = string:split(Addr0, ":", trailing),
	    {"IPv4", to_hex(inet:parse_address(Addr)), Port};
	{ok, V6Addr} ->
	    {"IPv6", to_hex({ok, V6Addr})}
    end.

-spec to_hex({ok, inet:ip_address()}) -> Hex :: binary().
to_hex({ok, {A,B,C,D}}) ->
    binary:encode_hex(<<A:8, B:8, C:8, D:8>>);
to_hex({ok, {A,B,C,D,E,F,G,H}}) ->
    binary:encode_hex(<<A:16, B:16, C:16, D:16, E:16, F:16, G:16, H:16>>).

print(Input, {Family, Hex, Port}) ->
    io:format("Input: ~s~nFamily: ~s~nHex: ~s~nPort: ~s~n~n",
	      [Input, Family, Hex, Port]);
print(Input, {Family, Hex}) ->
    io:format("Input: ~s~nFamily: ~s~nHex: ~s~n~n",
	      [Input, Family, Hex]).

data() ->
    ["127.0.0.1",
     "127.0.0.1:80",
     "::ffff:127.0.0.1",
     "::1",
     "[::1]:80",
     "1::80",
     "2605:2700:0:3::4713:93e3",
     "[2605:2700:0:3::4713:93e3]:80"].
