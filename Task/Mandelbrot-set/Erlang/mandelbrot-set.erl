  %% @author Salvador Tamarit <tamarit27@gmail.com>

-module(mandelbrot).

-export([test/0]).

magnitude(Z) ->
  R = complex:real(Z),
  I = complex:imaginary(Z),
  R * R + I * I.

mandelbrot(A, MaxI, Z, I) ->
    case (I < MaxI) and (magnitude(Z) < 2.0) of
        true ->
            NZ = complex:add(complex:mult(Z, Z), A),
            mandelbrot(A, MaxI, NZ, I + 1);
        false ->
            case I of
                MaxI ->
                    $*;
                _ ->
                    $
            end
    end.

test() ->
    lists:map(
        fun(S) -> io:format("~s",[S]) end,
        [
            [
                begin
                    Z = complex:make(X, Y),
                    mandelbrot(Z, 50, Z, 1)
                end
            || X <- seq_float(-2, 0.5, 0.0315)
            ] ++ "\n"
        || Y <- seq_float(-1,1, 0.05)
        ] ),
    ok.

% **************************************************
% Copied from https://gist.github.com/andruby/241489
% **************************************************

seq_float(Min, Max, Inc, Counter, Acc) when (Counter*Inc + Min) >= Max ->
  lists:reverse([Max|Acc]);
seq_float(Min, Max, Inc, Counter, Acc) ->
  seq_float(Min, Max, Inc, Counter+1, [Inc * Counter + Min|Acc]).
seq_float(Min, Max, Inc) ->
  seq_float(Min, Max, Inc, 0, []).

% **************************************************
