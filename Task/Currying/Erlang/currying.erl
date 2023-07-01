-module(currying).

-compile(export_all).

% Function that curry the first or the second argument of a given function of arity 2

curry_first(F,X) ->
    fun(Y) -> F(X,Y) end.

curry_second(F,Y) ->
    fun(X) -> F(X,Y) end.

% Usual curry

curry(Fun,Arg) ->
	case erlang:fun_info(Fun,arity) of
		{arity,0} ->
			erlang:error(badarg);
		{arity,ArityFun} ->
			create_ano_fun(ArityFun,Fun,Arg);
		_ ->
			erlang:error(badarg)
	end.

create_ano_fun(Arity,Fun,Arg) ->
	Pars =
		[{var,1,list_to_atom(lists:flatten(io_lib:format("X~p", [N])))}
		 || N <- lists:seq(2,Arity)],
	Ano =
		{'fun',1,
			{clauses,[{clause,1,Pars,[],
				[{call,1,{var,1,'Fun'},[{var,1,'Arg'}] ++ Pars}]}]}},
	{_,Result,_} = erl_eval:expr(Ano, [{'Arg',Arg},{'Fun',Fun}]),
	Result.

% Generalization of the currying

curry_gen(Fun,GivenArgs,PosGivenArgs,PosParArgs) ->
    Pos = PosGivenArgs ++ PosParArgs,
    case erlang:fun_info(Fun,arity) of
        {arity,ArityFun} ->
            case ((length(GivenArgs) + length(PosParArgs)) == ArityFun) and
                 (length(GivenArgs) == length(PosGivenArgs)) and
                 (length(Pos) == sets:size(sets:from_list(Pos))) of
                true ->
                    fun(ParArgs) ->
                        case length(ParArgs) == length(PosParArgs) of
                            true ->
                                Given = lists:zip(PosGivenArgs,GivenArgs),
                                Pars = lists:zip(PosParArgs,ParArgs),
                                {_,Args} = lists:unzip(lists:sort(Given ++ Pars)),
                                erlang:apply(Fun,Args);
                            false ->
                                erlang:error(badarg)
                        end
                    end;
                false ->
                    erlang:error(badarg)
            end;
        _ ->
            erlang:error(badarg)
    end.
