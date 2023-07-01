-module(convert_seconds).

-export([test/0]).

test() ->
	lists:map(fun convert/1, [7259, 86400, 6000000]),
	ok.

convert(Seconds) ->
	io:format(
		"~7s seconds = ~s\n",
		[integer_to_list(Seconds), compoundDuration(Seconds)] ).

% Compound duration of t seconds.  The argument is assumed to be positive.
compoundDuration(Seconds) ->
	intercalate(
		", ",
		lists:map(
			fun({D,L}) -> io_lib:format("~p ~s",[D, L]) end,
			compdurs(Seconds) ) ).

% Time broken down into non-zero durations and their labels.
compdurs(T) ->
	Ds =
		reduceBy(
			T,
			lists:map(
				fun(Dl) -> element(1,Dl) end,
				tl(durLabs()) ) ),
	lists:filter(
			fun(Dl) -> element(1,Dl) /= 0 end,
			lists:zip(
				Ds,
				lists:map(
					fun(Dl) -> element(2,Dl) end,
					durLabs() ) ) ).

% Duration/label pairs.
durLabs() ->
	[
		{undefined, "wk"},
		{7, "d"},
		{24, "hr"},
		{60, "min"},
		{60, "sec"}
	].

reduceBy(N, Xs) ->
	{N_, Ys} = mapaccumr(fun quotRem/2, N, Xs),
	[N_ | Ys].

quotRem(X1, X2) ->
	{X1 div X2, X1 rem X2}.

% **************************************************
% Adapted from http://lpaste.net/edit/47875
% **************************************************

mapaccuml(_,I,[]) ->
	{I, []};
mapaccuml(F,I,[H|T]) ->
	{Accum, NH} = F(I,H),
	{FAccum, NT} = mapaccuml(F,Accum,T),
	{FAccum, [NH | NT]}.

mapaccumr(_,I,[]) ->
	{I, []};
mapaccumr(F,I,L) ->
	{Acc, Ys} = mapaccuml(F,I,lists:reverse(L)),
	{Acc, lists:reverse(Ys)}.

% **************************************************


% **************************************************
% Copied from https://github.com/tim/erlang-oauth/blob/master/src/oauth.erl
% **************************************************

intercalate(Sep, Xs) ->
  lists:concat(intersperse(Sep, Xs)).

intersperse(_, []) ->
  [];
intersperse(_, [X]) ->
  [X];
intersperse(Sep, [X | Xs]) ->
  [X, Sep | intersperse(Sep, Xs)].

% **************************************************
