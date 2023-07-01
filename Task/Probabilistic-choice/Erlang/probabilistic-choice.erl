-module(probabilistic_choice).

-export([test/0]).

-define(TRIES, 1000000).

test() ->
	Probs =
		[{aleph,1/5},
		{beth,1/6},
		{gimel,1/7},
		{daleth,1/8},
		{he,1/9},
		{waw,1/10},
		{zayin,1/11},
		{heth,1759/27720}],
    random:seed(now()),
    Trials =
    	[get_choice(Probs,random:uniform()) || _ <- lists:seq(1,?TRIES)],
    [{Glyph,Expected,(length([Glyph || Glyph_ <- Trials, Glyph_ == Glyph])/?TRIES)}
    	 || {Glyph,Expected} <- Probs].

get_choice([{Glyph,_}],_) ->
	Glyph;
get_choice([{Glyph,Prob}|T],Ran) ->
	case (Ran < Prob) of
		true ->
			Glyph;
		false ->
			get_choice(T,Ran - Prob)
	end.
