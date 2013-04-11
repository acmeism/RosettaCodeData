-module(madlib).
-compile(export_all).

main() ->
    main([]).

main([]) ->
    madlib(standard_io);
main([File]) ->
    {ok, F} = file:open(File,read),
    madlib(F).

madlib(Device) ->
    {Dict, Lines} = parse(Device),
    Substitutions = prompt(Dict),
    print(Substitutions, Lines).

prompt(Dict) ->
    Keys = dict:fetch_keys(Dict),
    lists:foldl(fun (K,D) ->
                        S = io:get_line(io_lib:format("Please name a ~s: ",[K])),
                        dict:store(K, lists:reverse(tl(lists:reverse(S))), D)
                end, Dict, Keys).

print(Dict,Lines) ->
    lists:foreach(fun (Line) ->
                          io:format("~s",[substitute(Dict,Line)])
                  end, Lines).

substitute(Dict,Line) ->
    Keys = dict:fetch_keys(Dict),
    lists:foldl(fun (K,L) ->
                        re:replace(L,K,dict:fetch(K,Dict),[global,{return,list}])
                end, Line, Keys).

parse(Device) ->
    parse(Device, dict:new(),[]).

parse(Device, Dict,Lines) ->
    case io:get_line(Device,"") of
        eof ->
            {Dict, lists:reverse(Lines)};
        "\n" ->
            {Dict, lists:reverse(Lines)};
        Line ->
            parse(Device, parse_line(Dict, Line), [Line|Lines])
    end.

parse_line(Dict, Line) ->
    {match,Matches} = re:run(Line,"<.*?>",[global,{capture,[0],list}]),
    lists:foldl(fun ([M],D) ->
                        dict:store(M,"",D)
                end, Dict, Matches).
