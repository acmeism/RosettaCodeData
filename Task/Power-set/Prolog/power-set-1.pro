power_set(T, PS) :-
	bagof(PS1, power_set(T, [], PS1), PS).

power_set(T, PS, PS1) :-
	select(E, T, T1), !,
	append(PS, [E], PST),
	( PST = PS1;  power_set(T1, PS, PS1);  power_set(T1, PST, PS1)).

power_set([], [], []).
