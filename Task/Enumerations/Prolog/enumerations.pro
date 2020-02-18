fruit(apple,1).
fruit(banana,2).
fruit(cherry,4).

write_fruit_name(N) :-
	fruit(Name,N),
	format('It is a ~p~n', Name).
