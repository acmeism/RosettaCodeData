%%% @author Tony Wallace <tony@resurrection>
%%% @copyright (C) 2021, Tony Wallace
%%% @doc
%%% For details of the algorithms used see
%%% https://en.wikipedia.org/wiki/Modular_exponentiation
%%% @end
%%% Created : 21 Jul 2021 by Tony Wallace <tony@resurrection>

-module mod.
-export [mod_mult/3,mod_exp/3,binary_exp/2,test/0].

mod_mult(I1,I2,Mod) when
      I1 > Mod,
      is_integer(I1), is_integer(I2), is_integer(Mod) ->
    mod_mult(I1 rem Mod,I2,Mod);
mod_mult(I1,I2,Mod) when
      I2 > Mod,
      is_integer(I1), is_integer(I2), is_integer(Mod) ->
    mod_mult(I1,I2 rem Mod,Mod);
mod_mult(I1,I2,Mod) when
      is_integer(I1), is_integer(I2), is_integer(Mod) ->
    (I1 * I2) rem Mod.

mod_exp(Base,Exp,Mod) when
      is_integer(Base),
      is_integer(Exp),
      is_integer(Mod),
      Base > 0,
      Exp > 0,
      Mod > 0 ->
    binary_exp_mod(Base,Exp,Mod);
mod_exp(_,0,_) -> 1.


binary_exp(Base,Exponent) when
      is_integer(Base),
      is_integer(Exponent),
      Base > 0,
      Exponent > 0 ->
    binary_exp(Base,Exponent,1);
binary_exp(_,0) ->
    1.

binary_exp(_,0,Result) ->
    Result;
binary_exp(Base,Exponent,Acc) ->
    binary_exp(Base*Base,Exponent bsr 1,Acc * exp_factor(Base,Exponent)).


binary_exp_mod(Base,Exponent,Mod) ->
    binary_exp_mod(Base rem Mod,Exponent,Mod,1).
binary_exp_mod(_,0,_,Result) ->
   Result;
binary_exp_mod(Base,Exponent,Mod,Acc) ->
    binary_exp_mod((Base*Base) rem Mod,
		   Exponent bsr 1,Mod,(Acc * exp_factor(Base,Exponent))rem Mod).

exp_factor(_,0) ->
    1;
exp_factor(Base,1) ->
    Base;
exp_factor(Base,Exponent) ->
    exp_factor(Base,Exponent band 1).

test() ->
    445 = mod_exp(4,13,497),
    %% Rosetta code example:
    R = 1527229998585248450016808958343740453059 =
	mod_exp(2988348162058574136915891421498819466320163312926952423791023078876139,
		2351399303373464486466122544523690094744975233415544072992656881240319,
		binary_exp(10,40)),
    R.
% mod module ends here


%% Modified version of rosetta code entry
%% Modification was more efficient exponentiation
%% Modification - use of rpc:pmap to utilise multithreaded CPUs
-module(miller_rabin).

-export([is_prime/1,mr_series_test/4,mersennes/1,test/0]).

is_prime(1) -> false;
is_prime(2) -> true;
is_prime(3) -> true;
is_prime(N) when N > 3, ((N rem 2) == 0) -> false;
is_prime(N) when ((N rem 2) ==1), N < 341550071728321 ->
 			is_mr_prime(N, proving_bases(N));
is_prime(N) when ((N rem 2) == 1) ->
			is_mr_prime(N, random_bases(N, 100)).


proving_bases(N) when N < 1373653 ->
	[2, 3];
proving_bases(N) when N < 9080191 ->
    [31, 73];
proving_bases(N) when N < 25326001 ->
	[2, 3, 5];
proving_bases(N) when N < 3215031751 ->
	[2, 3, 5, 7];
proving_bases(N) when N < 4759123141 ->
    [2, 7, 61];
proving_bases(N) when N < 1122004669633 ->
	[2, 13, 23, 1662803];
proving_bases(N) when N < 2152302898747 ->
	[2, 3, 5, 7, 11];
proving_bases(N) when N < 3474749660383 ->
    [2, 3, 5, 7, 11, 13];
proving_bases(N) when N < 341550071728321 ->
    [2, 3, 5, 7, 11, 13, 17].


is_mr_prime(N, As) when N>2, N rem 2 == 1 ->
%    TStart = erlang:monotonic_time(),
    {D, S} = find_ds(N),
%    elapsed(TStart,"find_ds  took ~p.~p seconds~n"),
         %% this is a test for compositeness; the two case patterns disprove
         %%    compositeness.
    TestResults =
	rpc:pmap({miller_rabin,mr_series_test},[N,D,S],As),

    R= not lists:any(fun(X) -> X end,TestResults),
%    elapsed(TStart,"is_mr_prime took ~p.~p seconds~n"),
    R.

mr_series_test(A,N,D,S) ->
%    TMrS = erlang:monotonic_time(),
    R = case mr_series(N, A, D, S) of
	    [1|_] -> false;                     % first elem of list = 1
	    L     -> not lists:member(N-1, L)   % some elem of list = N-1
	end,
%    elapsed(TMrS,"mr_series took ~p.~p seconds~n"),
    R.

%elapsed(TStart,Msg) ->
%    TElapsed_ms = erlang:convert_time_unit(erlang:monotonic_time()-TStart,native,1000),
%    TSec = TElapsed_ms div 1000,
%    Tms = TElapsed_ms rem 1000,
%    io:format(Msg, [TSec,Tms]).


find_ds(N) ->
    find_ds(N-1, 0).

find_ds(D, S) ->
    case D rem 2 == 0 of
        true ->
            find_ds(D div 2, S+1);
        false ->
            {D, S}
    end.


mr_series(N, A, D, S) when N rem 2 == 1 ->
    Js = lists:seq(0, S),
    lists:map(fun(J) -> mod:mod_exp(A, mod:binary_exp(2, J)*D, N) end, Js).

random_bases(N, K) ->
    [basis(N) || _ <- lists:seq(1, K)].


basis(N) when N>2 ->
    % random:uniform returns a single random number in range 1 -> N-3,
    % to which is added 1, shifting the range to 2 -> N-2
    1 + rand:uniform(N-3).

mersennes(N) when N>0, is_integer(N) ->
    1 bsl N  - 1.

test() ->
    TStart = erlang:monotonic_time(),
    true = is_prime(7),
    true = is_prime(41),
    false = is_prime(42),
    true = is_prime(mersennes(31)),
    true = is_prime(mersennes(127)), % M(127) checks okay if 64 bit word size exceeded,
    true = is_prime(mersennes(3217)), % about the size of an rsa key,
    TFinish = erlang:monotonic_time(),
    ElapsedSeconds = erlang:convert_time_unit(TFinish - TStart,native,1),
    io:format("Time seconds = ~p~n",[ElapsedSeconds]),
    ok
    .
