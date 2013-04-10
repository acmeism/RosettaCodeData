main() ->
    SMA3 = sma(3),
    SMA5 = sma(5),
    Ns = [1, 2, 3, 4, 5, 5, 4, 3, 2, 1],
    lists:foreach(
      fun (N) ->
              io:format("Added ~b, sma(3) -> ~f, sma(5) -> ~f~n",[N,next(SMA3,N),next(SMA5,N)])
      end, Ns),
    stop(SMA3),
    stop(SMA5).

sma(W) ->
    {sma,spawn(?MODULE,loop,[W,[]])}.

loop(Window, Numbers) ->
    receive
        {_Pid, stop} ->
            ok;
        {Pid, N} when is_number(N) ->
            case length(Numbers) < Window of
                true ->
                    Next = Numbers++[N];
                false ->
                    Next = tl(Numbers)++[N]
            end,
            Pid ! {average, lists:sum(Next)/length(Next)},
            loop(Window,Next);
        _ ->
            ok
    end.

stop({sma,Pid}) ->
    Pid ! {self(),stop},
    ok.

next({sma,Pid},N) ->
    Pid ! {self(), N},
    receive
        {average, Ave} ->
            Ave
    end.
