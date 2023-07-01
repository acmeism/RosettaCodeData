%%% @author Tony Wallace <tony@tony.gen.nz>
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

%%%-------------------------------------------------------------------
%%% @author Tony Wallace <tony@tony.gen.nz>
%%% @doc
%%% Blocking not implemented.  Runtime exception if message too long
%%% Not a practical issue as RSA usually limited to symmetric key exchange
%%% However as a key exchange tool no advantage in compressing plaintext
%%% so that is not done either.
%%% @end
%%% Created : 24 Jul 2021 by Tony Wallace <tony@resurrection>
%%%-------------------------------------------------------------------

-module rsa.
-export([key_gen/2,encrypt/2,decrypt/2,test/0]).
-type key() :: {integer(),integer()}.
key_gen({N,D},E) ->
    {{E,N},{D,N}}.
-spec encrypt(key(),integer()) -> integer().
encrypt({E,N},MessageInt)
  when MessageInt < N ->
    mod:mod_exp(MessageInt,E,N).
-spec decrypt(key(),integer()) -> integer().
decrypt({D,N},Message) ->
    mod:mod_exp(Message,D,N).
test() ->
    PlainText=10722935,
    N = 9516311845790656153499716760847001433441357,
    E = 65537,
    D = 5617843187844953170308463622230283376298685,
    {PublicKey,PrivateKey} = key_gen({N,D},E),
    PlainText =:= decrypt(PrivateKey,
			  encrypt(PublicKey,PlainText)).
