%%% For details of the algorithms used see
%%% https://en.wikipedia.org/wiki/Modular_exponentiation

-module modexp_rosetta.
-export [mod_exp/3,binary_exp/2,test/0].

mod_exp(Base,Exp,Mod) when
      is_integer(Base),
      is_integer(Exp),
      is_integer(Mod),
      Base > 0,
      Exp > 0,
      Mod > 0 ->
    binary_exp_mod(Base,Exp,Mod).

binary_exp(Base,Exponent) ->
    binary_exp(Base,Exponent,1).
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
    mod_exp(2988348162058574136915891421498819466320163312926952423791023078876139,
	    2351399303373464486466122544523690094744975233415544072992656881240319,
	    binary_exp(10,40)).
