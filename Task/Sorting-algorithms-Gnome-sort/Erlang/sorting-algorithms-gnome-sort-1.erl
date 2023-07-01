-module(gnome_sort).
-export([gnome/1]).

gnome(L, []) -> L;
gnome([Prev|P], [Next|N]) when Next > Prev ->
	gnome(P, [Next|[Prev|N]]);
gnome(P, [Next|N]) ->
	gnome([Next|P], N).
gnome([H|T]) -> gnome([H], T).
