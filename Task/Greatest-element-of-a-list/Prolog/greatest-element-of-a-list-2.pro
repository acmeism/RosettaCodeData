max_list([H|T], Max) :-
	max_list(T, H, Max).

max_list([], Max, Max).
	
max_list([H|T], Max0, Max) :-
	H > Max0, !,
	max_list(T, H, Max).

max_list([_|T], Max0, Max) :-
	max_list(T, Max0, Max).
