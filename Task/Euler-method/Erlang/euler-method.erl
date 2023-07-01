-module(euler).
-export([main/0, euler/5]).

cooling(_Time, Temperature) ->
	(-0.07)*(Temperature-20).

euler(_, Y, T, _, End) when End == T ->
	io:fwrite("\n"),
	Y;

euler(Func, Y, T, Step, End) ->
	if
		T rem 10 == 0 ->
			io:fwrite("~.3f  ",[float(Y)]);
		true ->
			ok
	end,
	euler(Func, Y + Step * Func(T, Y), T + Step, Step, End).

analytic(T, End) when T == End ->
	io:fwrite("\n"),
	T;

analytic(T, End) ->
	Y = (20 + 80 * math:exp(-0.07 * T)),
	io:fwrite("~.3f  ", [Y]),
	analytic(T+10, End).

main() ->
	io:fwrite("Analytic:\n"),
	analytic(0, 100),
	io:fwrite("Step 2:\n"),
	euler(fun cooling/2, 100, 0, 2, 100),
	io:fwrite("Step 5:\n"),
	euler(fun cooling/2, 100, 0, 5, 100),
	io:fwrite("Step 10:\n"),
	euler(fun cooling/2, 100, 0, 10, 100),
	ok.
