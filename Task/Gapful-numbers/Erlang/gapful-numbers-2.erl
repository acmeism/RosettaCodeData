-module(stream).
-export([yield/1, naturals/0, naturals/1, filter/2, take/2, to_list/1]).

yield(F) when is_function(F) -> F().

naturals() -> naturals(1).
naturals(N) -> fun() -> {N, naturals(N+1)} end.

filter(Pred, Stream) ->
  fun() -> do_filter(Pred, Stream) end.

do_filter(Pred, Stream) ->
  case yield(Stream) of
    {X, Xs} ->
      case Pred(X) of
        true -> {X, filter(Pred, Xs)};
        false -> do_filter(Pred, Xs)
      end;
    halt -> halt
  end.

take(N, Stream) when N >= 0 ->
  fun() ->
    case yield(Stream) of
      {X, Xs} ->
        case N of
          0 -> halt;
          _ -> {X, take(N - 1, Xs)}
        end;
      halt -> halt
    end
  end.

to_list(Stream) -> to_list(Stream, []).
to_list(Stream, Acc) ->
  case yield(Stream) of
    {X, Xs} -> to_list(Xs, [X|Acc]);
    halt -> lists:reverse(Acc)
  end.
